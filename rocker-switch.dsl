Attribute "MaxAllowedForce": {unit: "Nm", defaultValue: 0.0, type: "double", description: "Max. allowed force"}
Attribute "AppliedForce": {description: "Applied force", defaultValue: 0.0, type: "double", unit: "Nm"}
Attribute "PowerConsumption": {description: "Power consumption", defaultValue: 0.0, type: "double",unit: "W"}

Product "S": {name: "Socket"}
Product "P": {name: "Pole"}
Product "SwC": {name: "Socket with Contacts"}

Resource "WC1": {name: "Work Cell 1", children: ["PositioningCell1", "Press1"]}
Resource "PositioningCell1": {name: "Positioning Cell 1", children: ["Drive1", "Drive2"]}
Resource "Drive1": {name: "Drive 1", requires: ["Drive2"]}
Resource "Drive2": {name: "Drive 2"}
Resource "Press1": {name: "Press 1"}

Process "InsertPress1": {
  name: "Insert/Press 1",
  inputs: [
    {productId: "S", minCost: 0.0, maxCost: 0.0},
    {productId: "P", minCost: 0.0, maxCost: 0.0}
  ],
  outputs: [
    {SwCOut: {productId: "SwC", costWeight: 1.0}} 
  ],
  resources: [
    {resourceId: "WC1", minCost: 0.0, maxCost: 0.0}
  ]
}

Product "Rocker": {name: "Rocker"}
Product "SwR": {name: "Socket with Rockers", MaxAllowedForce: 15}

Resource "WC2": {name: "Work Cell 2", children: ["PositioningCell2", "Press2"]}
Resource "PositioningCell2": {name: "Positioning Cell 2", children: ["Drive3", "Drive4"]}
Resource "Drive3": {name: "Drive 3", requires: ["Drive4"]}
Resource "Drive4": {name: "Drive 4"}
Resource "Press2": {name: "Press 2"}

Process "IsertPress2": {
  name: "Insert/Press 2",
  inputs: [
	{productId: "Rocker", minCost: 0.0, maxCost: 0.0},
	{productId: "SwC", comesFrom: "SwCOut"}
  ],
  outputs: [
	{IPOut: {productId: "SwR", costWeight: 1.0}}
  ],
  resources: [
	{resourceId: "WC2", minCost: 0.0, maxCost: 0.0}
  ]
}

Product "SwS": {name: "Socket with Screws"}
Product "S1": {name: "Screw 1", MaxAllowedForce: 4}
Product "S2": {name: "Screw 2", MaxAllowedForce: 4}

Resource "WC3": {name: "Work Cell 3",
  children: ["IPC", "Robot1", "ScrewDriver1", 
             "Robot2", "ScrewDriver2", "PositioningCell3"]}


Resource "PositioningCell3": {name: "Positioning Cell 3", children: ["Drive5", "Drive6"]}
Resource "Drive5": {name: "Drive 5", requires: ["Drive6"]}
Resource "Drive6": {name: "Drive 6"}

Resource "ScrewDriver": { name: "Screwdriver", 
  isAbstract: true, AppliedForce: 3 }
  
Resource "ScrewDriver1": {name: "Screwdriver 1", 
  children: ["Bit1", "Drive7"], 
  implements: ["ScrewDriver"]}
Resource "Bit1": {name: "Bit 1", 
  PowerConsumption: 5}
Resource "Drive7": {name: "Drive 7", 
  PowerConsumption: 10,
  children: ["Transformer1"]}
Resource "Transformer1": {name: "Transformer 1", 
  PowerConsumption: 15,
  children: ["ScrewerController1"]}
Resource "ScrewerController1": {
  name: "Screwer Controller 1",
  PowerConsumption: 20,
  requires: ["RobotController1"]}

Resource "Robot1": {name: "Robot 1", 
  children: ["RobotController1"]}
Resource "RobotController1": { name: "Robot Controller 1" }

Resource "ScrewDriver2": {name: "Screwdriver 2", 
  children: ["Bit2", "Drive8"], 
  implements: ["ScrewDriver"]}
Resource "Bit2": {name: "Bit 2", 
  PowerConsumption: 5}
Resource "Drive8": {name: "Drive 8", 
  PowerConsumption: 10,
  children: ["Transformer2"]}
Resource "Transformer2": {name: "Transformer 2", 
  PowerConsumption: 15,
  children: ["ScrewerController2"]}
Resource "ScrewerController2": {
  name: "Screwer Controller 2",
  PowerConsumption: 20,
  requires: ["RobotController2"]}

Resource "Robot2": {name: "Robot 2", 
  children: ["RobotController2"]}
Resource "RobotController2": { name: "Robot Controller 2" }

Resource "IPC": {name: "IPC", 
  requires: ["RobotController1", "RobotController2"], 
  children: ["PLC"]}
Resource "PLC": {name: "PLC"}

Process "InsertScrew": { name: "Insert/Screw",
  inputs: [
    {productId: "S1"}, {productId: "S2"},
    {productId: "SwR", comesFrom: "IPOut"}
  ],
  outputs: [ {SwSOut: {productId: "SwS", costWeight: 1.0}} ],
  resources: [ {resourceId: "WC3", minCost: 0.0, maxCost: 0.0} ]
}

Constraint "C1":{ definition: "ScrewDriver1, ScrewDriver2 max(AppliedForce) <= SwR.MaxAllowedForce"
}

Constraint "C2":{
  definition: "ScrewDriver1 descendants all -> all.PowerConsumption < 50"
}