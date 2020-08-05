## Example Owl BT Config
    {
        "nodes": [
            {
                "name": "node",
                "icon": "cube",
                "isAbstract": true
            },
            {
                "name": "action",
                "base": "node",
                "icon": "check-circle",
                "isAbstract": true
            },
            {
                "name": "execute",
                "base": "action",
                "icon": "bolt",
                "description": "{{function_name}}",
                "properties": [
                    {
                        "name": "function_name",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "execute_shared",
                "base": "action",
                "icon": "bolt",
                "description": "{{function_name}}",
                "properties": [
                    {
                        "name": "function_name",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "set_shared_value",
                "base": "action",
                "icon": "edit",
                "properties": [
                    {
                        "name": "key",
                        "type": "string"
                    },
                    {
                        "name": "value",
                        "type": "string"
                    },
                    {
                        "name": "data_type",
                        "type": "enum",
                        "values": [
                            "string",
                            "number",
                            "bool"
                        ]
                    }
                ]
            },
            {
                "name": "set_value",
                "base": "action",
                "icon": "edit",
                "properties": [
                    {
                        "name": "key",
                        "type": "string"
                    },
                    {
                        "name": "value",
                        "type": "string"
                    },
                    {
                        "name": "data_type",
                        "type": "enum",
                        "values": [
                            "string",
                            "number",
                            "bool"
                        ]
                    }
                ]
            },
            {
                "name": "subtree",
                "base": "action",
                "icon": "tree",
                "properties": [
                    {
                        "name": "module_name",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "dumb_jump",
                "base": "action",
                "icon": "bolt",
                "properties": [
                    {
                        "name": "jump_animation",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "dumb_step",
                "base": "action",
                "icon": "bolt",
                "description": "Use $target_pos, $target_height",
                "properties": [
                    {
                        "name": "jump_animation",
                        "type": "string"
                    },
                    {
                        "name": "walk_animation",
                        "type": "string"
                    },
                    {
                        "name": "speed_factor",
                        "type": "number"
                    },
                    {
                        "name": "timeout",
                        "type": "number"
                    }
                ]
            },
            {
                "name": "dumb_walk",
                "base": "action",
                "icon": "bolt",
                "properties": [
                    {
                        "name": "walk_animation",
                        "type": "string"
                    },
                    {
                        "name": "speed_factor",
                        "type": "number"
                    },
                    {
                        "name": "timeout",
                        "type": "number"
                    }
                ]
            },
            {
                "name": "fall_over",
                "base": "action",
                "icon": "bolt",
                "properties": [
                    {
                        "name": "fall_animation",
                        "type": "string"
                    },
                    {
                        "name": "fall_sound",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "free_jump",
                "base": "action",
                "icon": "bolt",
                "properties": [
                    {
                        "name": "jump_animation",
                        "type": "string"
                    },
                    {
                        "name": "jump_velocity",
                        "type": "number"
                    }
                ]
            },
            {
                "name": "get_nearby_entity",
                "base": "action",
                "icon": "bolt",
                "properties": [
                    {
                        "name": "entity_name",
                        "type": "string"
                    },
                    {
                        "name": "range",
                        "type": "number"
                    }
                ]
            },
            {
                "name": "get_nearby_player",
                "base": "action",
                "icon": "bolt",
                "properties": [
                    {
                        "name": "range",
                        "type": "number"
                    }
                ]
            },
            {
                "name": "get_random_pos",
                "base": "action",
                "icon": "bolt",
                "description": "Set $target_pos, $target_height",
                "properties": []
            },
            {
                "name": "get_target_pos",
                "base": "action",
                "icon": "bolt",
                "description": "Set $target_pos to $target_entity:get_pos()",
                "properties": []
            },
            {
                "name": "idle",
                "base": "action",
                "icon": "bolt",
                "description": "{{duration}} seconds",
                "properties": [
                    {
                        "name": "idle_animation",
                        "type": "string"
                    },
                    {
                        "name": "duration",
                        "type": "number"
                    }
                ]
            },
            {
                "name": "jump_attack",
                "base": "action",
                "icon": "bolt",
                "properties": [
                    {
                        "name": "idle_animation",
                        "type": "string"
                    },
                    {
                        "name": "charge_animation",
                        "type": "string"
                    },
                    {
                        "name": "charge_sound",
                        "type": "string"
                    },
                    {
                        "name": "attack_animation",
                        "type": "string"
                    },
                    {
                        "name": "attack_sound",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "jump_out",
                "base": "action",
                "icon": "bolt",
                "properties": []
            },
            {
                "name": "turn_to_pos",
                "base": "action",
                "icon": "bolt",
                "description": "Use $target_pos",
                "properties": []
            },
            {
                "name": "composite",
                "base": "node",
                "icon": "cubes",
                "isAbstract": true,
                "isComposite": true
            },
            {
                "name": "parallel",
                "base": "composite",
                "icon": "object-ungroup",
                "properties": [
                    {
                        "name": "strategy",
                        "default": "pass_certain",
                        "type": "enum",
                        "values": [
                            "pass_certain",
                            "fail_certain"
                        ]
                    },
                    {
                        "name": "target_count",
                        "type": "number"
                    }
                ]
            },
            {
                "name": "selector",
                "base": "composite",
                "icon": "question"
            },
            {
                "name": "sequence",
                "base": "composite",
                "icon": "arrow-right"
            },
            {
                "name": "condition",
                "base": "node",
                "icon": "flag",
                "isAbstract": true
            },
            {
                "name": "compare",
                "base": "condition",
                "icon": "flag",
                "description": "${{key}} {{predicate}} {{value}}",
                "properties": [
                    {
                        "name": "key",
                        "type": "string"
                    },
                    {
                        "name": "predicate",
                        "type": "enum",
                        "values": [
                            "~=",
                            "==",
                            ">=",
                            "<=",
                            "<",
                            ">"
                        ]
                    },
                    {
                        "name": "value",
                        "type": "string"
                    },
                    {
                        "name": "data_type",
                        "type": "enum",
                        "values": [
                            "string",
                            "number",
                            "bool"
                        ]
                    }
                ]
            },
            {
                "name": "has_shared_value",
                "base": "condition",
                "icon": "exclamation-circle",
                "properties": [
                    {
                        "name": "key",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "has_value",
                "base": "condition",
                "icon": "exclamation-circle",
                "properties": [
                    {
                        "name": "key",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "random",
                "base": "condition",
                "icon": "random",
                "description": "Chance {{probability}}",
                "properties": [
                    {
                        "name": "probability",
                        "type": "number"
                    }
                ]
            }
        ],
        "decorators": [
            {
                "name": "decorator",
                "icon": "cubes",
                "isAbstract": true
            },
            {
                "name": "precondition",
                "base": "decorator",
                "icon": "cubes",
                "isAbstract": true
            },
            {
                "name": "failure",
                "icon": "thumbs-o-down"
            },
            {
                "name": "inverter",
                "icon": "exchange"
            },
            {
                "name": "success",
                "icon": "thumbs-o-up"
            },
            {
                "name": "repeater",
                "icon": "recycle",
                "description": "Repeat {{repeat_times}} times",
                "properties": [
                    {
                        "name": "repeat_times",
                        "type": "number"
                    },
                    {
                        "name": "ignore_failure",
                        "default": false,
                        "type": "bool"
                    },
                    {
                        "name": "once_per_step",
                        "default": true,
                        "type": "bool"
                    }
                ]
            },
            {
                "name": "until_failure",
                "icon": "thumbs-o-down"
            },
            {
                "name": "until_success",
                "icon": "thumbs-o-up"
            }
        ],
        "services": [
        ]
    }
