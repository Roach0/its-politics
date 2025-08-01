## Development Phases

### Phase 1: Core Networking (2-3 weeks)

1. ~~Steam integration for lobby system~~
2. ~~Basic peer-to-peer connection handling~~
3. ~~Player join/leave handling~~
4. Game state synchronization foundation

### Phase 2: Basic Game Framework (3-4 weeks)

1. Board representation
2. Position system with flow mechanics
3. Official placement and movement
4. Turn system implementation

### Phase 3: Game Mechanics (4-5 weeks)

1. Card system implementation
2. Asset system
3. Government types and transitions
4. TTP (Time To Play) system

### Phase 4: UI/UX (2-3 weeks)

1. Lobby interface
2. Game board visualization
3. Card hand interface
4. Player information display

### Phase 5: Polish & Testing (2-3 weeks)

1. Network stability testing
2. Game flow testing
3. Edge case handling
4. Performance optimization

## Specific Technical Considerations

1. **Steam Integration**
    
    - Use Godot Steam API addon
    - Implement lobby creation/joining
    - Handle Steam friend invites
    - Steam P2P networking
2. **State Synchronization**
    
    - Use RPCs for all game state changes
    - Host validates all moves
    - State verification system to prevent desyncs
3. **Turn Management**
    
    - Clear turn phases
    - Timeout handling
    - Disconnection handling
4. **Data Management**
    
    - Load game data (cards, officials, etc.) from JSON
    - Runtime caching for performance
    - Version checking for data files