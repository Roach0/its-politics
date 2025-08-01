# Phase 2: Basic Game Framework Implementation Guide

## Code Structure

### Government Type (government_type.gd)
```gdscript
# scripts/resources/government_type.gd
class_name GovernmentType
extends Resource

var name: String
var positions: Array[Position] = []
var flow_connections = {}  # Dictionary of position_id: [connected_position_ids]

func _init(gov_name: String):
    name = gov_name

func get_flow_destinations(position_id: int) -> Array:
    return flow_connections.get(position_id, [])
```

### Board System (board.gd)
```gdscript
# scripts/classes/board.gd
class_name Board
extends Node2D

signal position_vacated(position_id: int)
signal position_filled(position_id: int, official: Official)
signal government_changed(new_type: String)

var current_government: GovernmentType
var positions = {}  # Dictionary of position_id: Position
var position_nodes = {}  # Dictionary of position_id: PositionNode (visual representation)

func change_government(new_gov_type: String):
    # Save current officials
    var current_officials = {}
    for pos_id in positions:
        if positions[pos_id].has_official():
            current_officials[pos_id] = positions[pos_id].get_official()
    
    # Update board layout
    current_government = load_government_type(new_gov_type)
    setup_positions()
    
    # Handle official transitions/deaths based on new government rules
    handle_government_transition(current_officials)

func handle_flow_mechanics(vacated_position_id: int):
    var flow_positions = current_government.get_flow_destinations(vacated_position_id)
    for pos_id in flow_positions:
        if positions[pos_id].has_official():
            var official = positions[pos_id].remove_official()
            positions[vacated_position_id].place_official(official)
            # This might trigger more flows, handle recursively
```

### Position System (position.gd)
```gdscript
# scripts/classes/position.gd
class_name Position
extends Node2D

signal official_placed(official: Official)
signal official_removed(official: Official)

var position_id: int
var position_type: String
var current_official: Official = null
var scoring_multipliers = {
    "Intel": 1.0,
    "Wealth": 1.0,
    "Profile": 1.0,
    "Military": 1.0
}

func place_official(official: Official) -> bool:
    if current_official != null:
        return false
    current_official = official
    official_placed.emit(official)
    return true

func remove_official() -> Official:
    var official = current_official
    if official:
        current_official = null
        official_removed.emit(official)
    return official

func calculate_score() -> Dictionary:
    if not current_official:
        return {}
    
    var scores = {}
    for asset in current_official.assets:
        var base_score = asset.get_base_score()
        scores[asset.owner_id] = base_score * scoring_multipliers[asset.type]
    return scores
```

### Official System (official.gd)
```gdscript
# scripts/classes/official.gd
class_name Official
extends Node2D

signal ttp_updated(new_value: int)
signal asset_added(asset: Asset)
signal asset_removed(asset: Asset)
signal official_died()

var official_id: String
var ttp: int  # Time To Play
var assets: Array[Asset] = []
var position_id: int = -1

func _init(id: String, initial_ttp: int):
    official_id = id
    ttp = initial_ttp

func add_asset(asset: Asset) -> bool:
    assets.append(asset)
    asset_added.emit(asset)
    return true

func remove_asset(asset: Asset) -> bool:
    var idx = assets.find(asset)
    if idx != -1:
        assets.remove_at(idx)
        asset_removed.emit(asset)
        return true
    return false

func update_ttp(delta: int):
    ttp += delta
    if ttp <= 0:
        die()
    ttp_updated.emit(ttp)

func die():
    official_died.emit()
    queue_free()
```

### Turn System (turn_manager.gd)
```gdscript
# scripts/autoload/turn_manager.gd
extends Node

signal turn_started(player_id: int)
signal turn_ended(player_id: int)
signal round_started(round_number: int)
signal round_ended(round_number: int)

var current_player_id: int = -1
var players: Array = []
var round_number: int = 0
var first_player_index: int = 0

func start_game(player_ids: Array):
    players = player_ids
    round_number = 1
    first_player_index = 0
    start_round()

func start_round():
    round_started.emit(round_number)
    current_player_id = players[first_player_index]
    start_turn()

func start_turn():
    turn_started.emit(current_player_id)

@rpc("any_peer", "reliable")
func end_turn():
    if multiplayer.get_remote_sender_id() != current_player_id:
        return
        
    turn_ended.emit(current_player_id)
    
    # Find next player
    var current_index = players.find(current_player_id)
    var next_index = (current_index + 1) % players.size()
    
    # If we're back to the first player, end the round
    if next_index == first_player_index:
        end_round()
    else:
        current_player_id = players[next_index]
        start_turn()

func end_round():
    round_ended.emit(round_number)
    first_player_index = (first_player_index + 1) % players.size()
    round_number += 1
    start_round()
```

## Implementation Timeline

### Week 1: Basic Board Setup
- Implement base board class
- Create position nodes and visual representation
- Set up government type switching
- Test basic board layout changes

### Week 2: Position and Flow Mechanics
- Implement position class with official handling
- Create flow connection system
- Test position connections and flow mechanics
- Implement position scoring multipliers

### Week 3: Official and Asset System
- Create official class with TTP system
- Implement asset attachment/detachment
- Set up official death handling
- Test official placement and movement

### Week 4: Turn System Integration
- Implement turn manager
- Connect turn system with board actions
- Add round management
- Test full game flow

## Testing Checklist

### Board Layout Tests
- [ ] Verify correct position setup for each government type
- [ ] Test government type transitions
- [ ] Ensure positions maintain correct connections

### Flow Mechanics Tests
- [ ] Test official movement when positions are vacated
- [ ] Verify flow chain reactions work correctly
- [ ] Ensure officials maintain their assets during movement

### Official Management Tests
- [ ] Test TTP countdown system
- [ ] Verify asset attachment/detachment
- [ ] Test official death and cleanup

### Turn Flow Tests
- [ ] Verify correct player order
- [ ] Test round completion and new round start
- [ ] Ensure first player token moves correctly