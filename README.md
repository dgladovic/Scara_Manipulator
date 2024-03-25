# Scara_Manipulator
Scara robot for manipulation tasks

# Kinematic Analysis

## Direct Kinematic Problem
The direct kinematic problem (task) involves determining the relations through which external coordinates (in general, the position and orientation of the robot's end effector) can be uniquely expressed using internal coordinates (joint displacements of the robot). The solution to this problem is obtained using the Rodrigues' approach, i.e., by using Rodrigues' transformation matrices. In general, the Rodrigues transformation matrix is calculated as:

[A_k−1,k] = [ I ] + ξ_k * ((1 − cos(q_k)) * [e_k_d]^2 + sin(q_k) * [e_k_d])

Where ξ_k is equal to 1 if the joint is revolute (allowing rotation) and 0 if it is prismatic (allowing translation). q_k is the value of the generalized coordinate, while [e_k_d] is the dual object of the unit vector of the rotation axis, calculated as:

e_k^(k) = {
e_k1
e_k2
e_k3
} → [e_k_d] = [
0 -e_k3 e_k2
e_k3 0 -e_k1
-e_k2 e_k1 0
]

The concept of the dual object is introduced for easier implementation of the vector product since it holds that:

{ a⃗ × b⃗ } = [a_d]{ b⃗ }

The position of the robot's end effector in the fixed coordinate system can be calculated as:
r⃗_H(0) = [A_0,1] ∙ {ρ⃗_11(1)} + [A_0,2] ∙ {ρ⃗_22(2)} + [A_0,3] ∙ {ρ⃗_33(3)} + [A_0,4] ∙ {ρ⃗_44(4)}

[A_0,2] = [A_0,1] ∙ [A_1,2]

[A_0,3] = [A_0,2] ∙ [A_2,3]

[A_0,4] = [A_0,3] ∙ [A_3,4]

It can be easily concluded that the matrices [A_0,1] and [A_3,4] are identity matrices, while the other two matrices are obtained using the Rodrigues pattern.

[A_1,2] = [
cos(q_1) -sin(q_1) 0
sin(q_1) cos(q_1) 0
0 0 1
]

[A_2,3] = [ cos(q_2) -sin(q_2) 0
            sin(q_2) cos(q_2) 0
0 0 1
]

From the figure, it can be seen that:

{ρ⃗_11(1)} = {
0
0
188
}

{ρ⃗_22(2)} = {
150
0
0
}

{ρ⃗_33(3)} = {
0
0
-25
}

{ρ⃗_44(4)} = {
105
0
0
}

The solution to the direct kinematic problem is then:

r⃗_H(0) = {
x_H
y_H
z_H
} = {
150cos(q_1) + 105cos(q_1 + q_2)
150sin(q_1) + 105sin(q_1 + q_2)
163
}
