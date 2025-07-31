class_name Government
extends Control

@export var government_type: GovernmentType

var offices: Array[Office] = []

func can_promote(office_id: int) -> bool:
    return government_type.allowed_promotions.has(office_id)

func promote_official(office_id: int):
    if can_promote(office_id):
        offices[office_id + 1].official = offices[office_id].official
        offices[office_id].official = null
    else:
        print("Cannot promote official in office ", office_id)

