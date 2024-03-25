# Scara_Manipulator
Scara robot for manipulation tasks

<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Physical_structure.png" width="360" height="auto"  style="margin-right:24px;"/>
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Kinematic_scheme.jpg" width="360" height="auto" />
</div>

## Index

1. [Kinematic Analysis](#kinematic-analysis)
    - [Direct Kinematic Problem](#direct-kinematic-problem)
    - [Inverse Kinematic Problem](#inverse-kinematic-problem)
2. [Design of Control Software](#design-of-control-software)
    - [Control Algorithm](#control-algorithm)
    - [Look up Table](#look-up-table)

# Kinematic Analysis

## Direct Kinematic Problem
The direct kinematic problem (task) involves determining the relations through which external coordinates (in general, the position and orientation of the robot's end effector) can be uniquely expressed using internal coordinates (joint displacements of the robot). The solution to this problem is obtained using the Rodrigues' approach, i.e., by using Rodrigues' transformation matrices. In general, the Rodrigues transformation matrix is calculated as:
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Rodrigo1.png"/>
</div>
Where ξ_k is equal to 1 if the joint is revolute (allowing rotation) and 0 if it is prismatic (allowing translation). q_k is the value of the generalized coordinate, while [e_k_d] is the dual object of the unit vector of the rotation axis, calculated as:
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Rodrigo2.png"/>
</div>

The concept of the dual object is introduced for easier implementation of the vector product since it holds that:
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Rodrigo3.png"/>
</div>
The position of the robot's end effector in the fixed coordinate system can be calculated as:
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Rodrigo4.png"/>
</div>

It can be easily concluded that the matrices [A_0,1] and [A_3,4] are identity matrices, while the other two matrices are obtained using the Rodrigues pattern.
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Rodrigo5.png"/>
</div>

From the figure, it can be seen that:
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Rodrigo%206.png"/>
</div>

The solution to the direct kinematic problem is then:
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Rodrigo7.png"/>
</div>

## Inverse Kinematic Problem
<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Kinematic_coordinates.png" width="320" height="auto" border="10" margin="auto"/>
</div>

The solution to the inverse kinematic problem of a horizontal anthropomorphic robot configuration with two degrees of freedom (SCARA) is relatively simple (unlike the general case) and can be obtained by simple application of trigonometry. From the figure, it can be seen that for each position of the robot's end effector, two solutions or configurations are possible. By applying the cosine theorem, the first solution is:

<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Inv1.png"/>
</div>

While the second solution is:

<div align="center">
  <img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Inv2.png"/>
</div>

# Design of Control Software

The control software of the robotic system is implemented using the mikroC Pro for PIC development environment, which is based on the C programming language. The implementation of algorithms used to determine the path along which the robot's end effector will move between the current position and the desired point, as well as the necessary calculations for inverse kinematics to achieve this movement, are implemented using the MATLAB software package. Using the same package, a GUI (Graphic User Interface) has been developed to control the robot.

## Control Algorithm

The workspace of the robotic system can be easily determined if the maximum rotations of the robot's joints are known. By using the solution to the direct kinematic problem and varying the values of internal coordinates between the maximum joint angles, a grid of points representing the workspace is obtained.

<div align="center">
<img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Computed_space.png" width="320" height="auto" border="10" margin="auto"/>
</div>

In the image, it can be observed that one part of the workspace grid is denser, representing the part of the workspace where the robot can be located in both configurations. This is better illustrated in the following image, where the zones in which the robot can be located in only one configuration are clearly delineated. Further designation will be used, where the zone in which the robot can only be in one configuration and the y-coordinate is positive, represents zone 1 (consistent with the fact that the robot's end effector can be located in that zone only if it is in configuration 1, i.e., the solution to the inverse kinematics is solution 1 in accordance with the maximum joint rotation), while the zone in which y is negative is called zone 2. Zone 4 represents the part where the robot's end effector can be located in both configurations, while zone 3 denotes the part of the space outside the reach of the robot's end effector. Additionally, auxiliary points A and B are marked, which will be discussed later.

<div align="center">
<img src="https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Segmented_Comp_space.png" width="320" height="auto" border="10" margin="auto"/>
</div>

It is envisioned that the end effector of the robot gripper moves to the desired point in a straight line. This is a somewhat more complex task but allows for certain advantages, such as avoiding any obstacles that may be present in the workspace. As the first step in the algorithm, it is necessary to determine in which zone the robot's end effector is currently located and in which zone the point to which the end effector is desired to be brought is located. For this purpose, the following functions are used to determine whether a point or part of the path belongs to a certain area.

[area-1](https://github.com/dgladovic/Scara_Manipulator/blob/main/oblast1.m)
[area-2](https://github.com/dgladovic/Scara_Manipulator/blob/main/oblast2.m)
[area-3](https://github.com/dgladovic/Scara_Manipulator/blob/main/oblast3.m)

The conditions that the function checks represent the geometric description of these areas.

```

if oblast1([xH, yH])==1
pozH = 1;
elseif oblast2([xH, yH])==1
pozH = 2;
else
pozH = 4;
end
if oblast1([xT, yT])==1
pozT = 1;
elseif oblast2([xT, yT])==1
pozT = 2;
else
pozT = 4;
end
if (konf==1 && pozT==2) || (konf==2 && pozT==1)
promena_konf = 1;
else
promena_konf = 0;
end
if promena_konf == 1 && pozH == 4
[konf,M01,M02] = menjaj_konf2(konf, xH, yH,n,broj,korak)
end

```

Variable konf represents the configuration number in which the robot is currently located. In our case, it will always be 1 at the initial moment because the robot will always move from the farthest point in zone 1 (maximum values of internal coordinates). Therefore, if the robot is in configuration 1 and the point it needs to reach is in zone 2 (and vice versa), it is certain that the robot will need to change its configuration at some point. Also, if the robot is currently in zone 4 and it needs to change configuration to reach the desired point, then changing the configuration will be the first thing it will do.

The values of the pulse count that need to be sent to the motors, as well as their direction to change the configuration, are obtained using the function menjaj_konf2 and stored in matrices M01 and M02, where 0 indicates a configuration change, and 1 and 2 indicate joints or motors 1 and 2, respectively. A detailed description of the matrix notation will be given below.

[Check robot configuration](https://github.com/dgladovic/Scara_Manipulator/blob/main/menjaj_konf3.m)

Within this function, there is also an animation of the movement of robot segments during configuration change.

Further development involves an algorithm to determine the path of the robot's end effector to the desired point. Here, it will be briefly described, while the complete part of the code related to this control will be provided below. First, the function putanja.m is used, which provides a set of discrete points between two points that belong to a straight line drawn between those two points.

[Path function](https://github.com/dgladovic/Scara_Manipulator/blob/main/putanja.m)

Using a series of if-else branches, the shortest straight-line path to the desired point is sought, using auxiliary points A and B if direct straight-line movement to the desired point is not possible. Several examples will be considered.

First, it is checked whether the initially calculated path (straight line between the robot's end effector and the desired point) belongs to zone 3, i.e., whether it partially exits the robot's workspace. If this is true, there are several possibilities. The first one is that the robot's end effector is in zone 1 and the desired point is in zone 2. If this is the case, the robot's end effector will first move to auxiliary point A, then change its configuration there. Then the robot will move to auxiliary point B and then to the desired point. If the reverse is true (the robot's end effector is in zone 2 and the desired point is in zone 1), the procedure is analogous: point B, configuration change, point A, desired point.

```

if oblast3(pp) == 1
if pozH == 1 && pozT == 2
pp = putanja([xH,yH],[xA,yA],broj);
[B] = kretanje(broj, [xH,yH], [xA,yA],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xA,yA],konf,n)
[konf,M01,M02] = menjaj_konf2(konf, xA, yA,n,broj,korak)
pp = putanja([xA,yA],[xB,yB],broj);
[B] = kretanje(broj, [xA,yA], [xB,yB],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xA,yA], [xB,yB],konf,n)
pp = putanja([xB,yB],[xT,yT],broj);
[B] = kretanje(broj, [xB,yB],[xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xB,yB], [xT,yT],konf,n)
elseif pozH == 2 && pozT == 1
pp = putanja([xH,yH],[xB,yB],broj);
[B] = kretanje(broj, [xH,yH], [xB,yB],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xB,yB],konf,n)
[konf,M01,M02] = menjaj_konf2(konf, xB, yB,n,broj,korak)
pp = putanja([xB,yB],[xA,yA],broj);
[B] = kretanje(broj, [xB yB], [xA yA],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xB,yB], [xA,yA],konf,n)
pp = putanja([xA,yA],[xT,yT],broj);
[B] = kretanje(broj, [xA, yA], [xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xA,yA], [xT,yT],konf,n)
elseif pozH == 4 && pozT == 1
pp = putanja([xH,yH],[xA,yA],broj);
if oblast3(pp) == 1
pp = putanja([xH,yH],[xB,yB],broj);
[B] = kretanje(broj, [xH,yH], [xB,yB],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xB,yB],konf,n)
pp = putanja([xB,yB],[xA,yA],broj);
[B] = kretanje(broj, [xB,yB], [xA,yA],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xB,yB], [xA,yA],konf,n)
else
[B] = kretanje(broj, [xH,yH], [xA,yA],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xA,yA],konf,n)
end
pp = putanja([xA,yA],[xT,yT],broj);
[B] = kretanje(broj, [xA,yA], [xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xA,yA], [xT,yT],konf,n)
elseif pozH == 4 && pozT == 2
pp = putanja([xH,yH],[xB,yB],broj);
if oblast3(pp) == 1
pp = putanja([xH,yH],[xA,yA],broj);
[B] = kretanje(broj, [xH,yH], [xA,yA],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xA,yA],konf,n)
pp = putanja([xA,yA],[xB,yB],broj);
[B] = kretanje(broj, [xA,yA], [xB,yB],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xA,yA], [xB,yB],konf,n)
else
[B] = kretanje(broj, [xH,yH], [xB,yB],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xB,yB],konf,n)
end
pp = putanja([xB,yB],[xT,yT],broj);
[B] = kretanje(broj, [xB,yB], [xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xB,yB], [xT,yT],konf,n)
elseif pozH == 1 && pozT == 4
pp = putanja([xH,yH],[xA,yA],broj);
[B] = kretanje(broj, [xH,yH], [xA,yA],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xA,yA],konf,n)
pp = putanja([xA,yA],[xT,yT],broj);
if oblast3(pp) == 1
pp = putanja([xA,yA],[xB,yB],broj);
[B] = kretanje(broj, [xA,yA], [xB,yB],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xA,yA], [xB,yB],konf,n)
pp = putanja([xB,yB],[xT,yT],broj);
[B] = kretanje(broj, [xB,yB], [xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xB,yB], [xT,yT],konf,n)
elseif oblast2(pp) == 1
promena_konf = 1;
[konf,M01,M02] = menjaj_konf2(konf, xA, yA,n,broj,korak)
[B] = kretanje(broj, [xA,yA], [xT,yT],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xA,yA], [xT,yT],konf,n)
else
[B] = kretanje(broj, [xA,yA], [xT,yT],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xA,yA], [xT,yT],konf,n)
end
elseif pozH == 2 && pozT == 4
pp = putanja([xH,yH],[xB,yB],broj);
[B] = kretanje(broj, [xH,yH], [xB,yB],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xB,yB],konf,n)
pp = putanja([xB,yB],[xT,yT],broj);
if oblast3(pp) == 1
pp = putanja([xB,yB],[xA,yA],broj);
[B] = kretanje(broj, [xB,yB], [xA,yA],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xB,yB], [xA,yA],konf,n)
pp = putanja([xA,yA],[xT,yT],broj);
[B] = kretanje(broj, [xA,yA], [xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xA,yA], [xT,yT],konf,n)
elseif oblast1(pp) == 1
promena_konf = 1;
[konf,M01,M02] = menjaj_konf2(konf, xB, yB,n,broj,korak)
[B] = kretanje(broj, [xB,yB], [xT,yT],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xB,yB], [xT,yT],konf,n)
else
[B] = kretanje(broj, [xB,yB], [xT,yT],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xB,yB], [xT,yT],konf,n)
end
elseif pozH == 4 && pozT == 4
pp = putanja([xH,yH],[xA,yA],broj);
if oblast3(pp) == 1
pp = putanja([xH,yH],[xB,yB],broj);
[B] = kretanje(broj, [xH,yH], [xB,yB],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xB,yB],konf,n)
pp = putanja([xB,yB],[xA,yA],broj);
[B] = kretanje(broj, [xB,yB], [xA,yA],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xB,yB], [xA,yA],konf,n)
pp = putanja([xA,yA],[xT,yT],broj);
[B] = kretanje(broj, [xA,yA], [xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xA,yA], [xT,yT],konf,n)
else
[B] = kretanje(broj, [xH,yH], [xA,yA],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xA,yA],konf,n)
pp = putanja([xA,yA],[xB,yB],broj);
[B] = kretanje(broj, [xA,yA], [xB,yB],konf);
[M21,M22] = mot(korak,B)
stablo(broj, [xA,yA], [xB,yB],konf,n)
pp = putanja([xB,yB],[xT,yT],broj);
[B] = kretanje(broj, [xB,yB], [xT,yT],konf);
[M31,M32] = mot(korak,B)
stablo(broj, [xB,yB], [xT,yT],konf,n)
end
end
else
pp = putanja([xH,yH],[xT,yT],broj);
[B] = kretanje(broj, [xH,yH], [xT,yT],konf);
[M11,M12] = mot(korak,B)
stablo(broj, [xH,yH], [xT,yT],konf,n)
end

```

The algorithm also uses some other functions such as kretanje.m, mot.m, and stablo.m. The idea is to divide the path between two points into a certain number of points and then determine the relative displacements of the joints that need to be achieved to sequentially move the robot's end effector to those points. This is achieved by solving the inverse kinematic problem for those points. The kretanje.m function returns a matrix containing four columns. The first column represents the relative displacements of joint 1, while the elements in the second column are equal to 1 if the relative displacement is positive and 0 if it is negative. Columns 3 and 4 contain the same elements for joint 2.

[Create path](https://github.com/dgladovic/Scara_Manipulator/blob/main/kretanje.m)
[Prepare commands for motor](https://github.com/dgladovic/Scara_Manipulator/blob/main/mot.m)
[Draw the tree](https://github.com/dgladovic/Scara_Manipulator/blob/main/stablo.m)

The mot.m function takes as arguments a matrix obtained previously and the step of the motor. Based on this, it calculates the number of pulses needed to be sent to the motors to achieve the specified movement, while retaining information about the direction in which the specified movement needs to be achieved.
Now, let's discuss how the values of the pulse count and motor rotation direction are formatted and sent to the microcontroller using the UART protocol.
As seen from the part of the code where the path of the robot's end effector is determined, the number of pulses and direction of rotation are stored in matrices of the form M01, M02, M11, M12, M21, M22, etc.
The first number indicates the part of the path to which it refers, where the number 0 indicates a configuration change, while the second number indicates which joint is involved. These matrices need to be packed into one cell in the order in which they will be sent to the microcontroller, i.e., the order in which they need to be executed.

```

i = 1;
if (oblast1([xH yH])~=1 && oblast2([xH yH])~=1)
if (exist('M01', 'var') == 1)
M{i,1} = M01;
M{i,2} = M02;
i = i+1;
end
M{i,1} = M11;
M{i,2} = M12;
i = i+1;
if (exist('M21', 'var') == 1)
M{i,1} = M21;
M{i,2} = M22;
i = i+1;
end
if (exist('M31', 'var') == 1)
M{i,1} = M31;
M{i,2} = M32;
i = i+1;
end
else
M{i,1} = M11;
M{i,2} = M12;
i=i+1;
if promena_konf == 1
M{i,1} = M01;
M{i,2} = M02;
i = i+1;
end
if (exist('M21', 'var') == 1)
M{i,1} = M21;
M{i,2} = M22;
i = i+1;
end
if (exist('M31', 'var') == 1)
M{i,1} = M31;
M{i,2} = M32;
i = i+1;
end
end

```

A variable i is used, whose initial value is 1 and is incremented by 1 each time a specific matrix is stored in a cell.

According to the previously described algorithm, if the robot's end effector is currently not in zone 1 or zone 2, it means that if a configuration change is needed, it will be the first thing the robot does, and therefore the matrices with information about the configuration change (M01, M02) will be the first ones stored in the cell. Next, it checks which matrices exist (depending on how many segments the path is divided into) and stores them sequentially in the cell. If the robot's end effector is in zone 1 or zone 2, then M11 and M12 will certainly be executed first. Then it checks if there is a configuration change, and if so, it is the next operation performed because according to the previous algorithm, in such situations, the configuration change is always made at the auxiliary point. It then checks if parts of the path M21, M22, and M31, M32 exist, and stores them sequentially in the M cell.

Since each path in the algorithm is divided into a large number of discrete points (specifically 60), and considering the dimensions of the workspace and the step of the motor, it means that the pulse count values needed to be sent to the motor to move from one point to the adjacent point are far less than 255, which is possible to send via UART communication, considering that it is possible to send eight-bit data types. In fact, it has been determined that this value never exceeds 30, so it is possible to use the first 7 bits for it (which gives us the ability to record up to 127), while the highest, eighth bit, is used for the direction of rotation information, which will enable memory savings on the microcontroller. This is implemented by the following part of the code.


```

x = uint8(0);
maska = uint8(127);
[m,~] = size(M);
i = 1;
j = 1;
k = 1;
for i = 1:m
for j = 1:(broj-1)
for k = 1:2
x = bitand(M{i,k}(j,1), maska); % maskira se prvi motor, j-a
vrednost, i-te putanje
if M{i,k}(j,2) == 1
x = bitor(uint8(128), x);
end
Mbit{i,k}(j,1) = x;
end
end
end

```

Built-in functions `bitand` and `bitor` are used, which represent logical AND and OR operations on bits. First, using `bitand` on the pulse count and a mask that has a one on the first 7 bits and zero on the eighth bit, only the last bit is cleared while the first seven bits retain their state. Then, if the direction is positive (i.e., the element in the second column is equal to one), the last bit is set, and if the direction is negative, that bit remains zero. This is achieved by using the `bitor` function on the previously obtained variable `x` and the number 128, where only the highest bit is set.

These packed data are now ready to be sent over the serial port, which was opened earlier in the code.


```

s = serial('COM10');
s.BaudRate = 38400;
s.Timeout = 5;
s.InputBufferSize = 10000;
s.OutputBufferSize = 10000;
s.Terminator = 'CR/LF';
flushinput(s)
flushoutput(s)
fopen(s)
i = 1;
j = 1;
for i = 1:m
for j = 1:(broj-1)
fwrite(s,Mbit{i,1}(j,1),'uint8'); %salje se broj pulseva i
smer motora 1
%pause(0.1);
fwrite(s,Mbit{i,2}(j,1),'uint8'); %salje se broj pusleva i
smer motora 2
%pause(0.1);
end
pause(5)
end

```

A pause of 5 seconds exists so that the microcontroller has time to execute the sequence, i.e., send pulses to the motors, after receiving data for one part of the path, before receiving data about the next part of the path.

After the entire sequence is executed and the robot's end effector reaches the specified point, the coordinates of the current position of the robot's end effector take the values of the coordinates of the specified point. It is also necessary to clear all matrices containing information about the number of pulses for the motors and their rotation directions so that the robot is ready for a new set of coordinates.

```

xH = xT;
yH = yT;
if (exist('M01', 'var') == 1)
clear M01;
clear M02;
end
if (exist('M11', 'var') == 1)
clear M11;
clear M12;
end
if (exist('M21', 'var') == 1)
clear M21;
clear M22;
end
if (exist('M31', 'var') == 1)
clear M31;
clear M32;
end
clear M;
clear Mbit;

```

# "Look up" table

Here is a different approach to solving the robot control problem. Unlike the previous solution, first all possible achievable positions of the robot's gripper are determined. This is done by combining all possible discrete positions of the joint motors (q1,q2) using equations obtained by solving the inverse kinematic problem. Vectors T1 and T2 represent all possible values of internal coordinates (angular displacements of the motors). By combining these two vectors, we obtain two matrices (X,Y) that show the values of achievable gripper positions for that combination of pairs (q1,q2). These values are stored in the LAP.mat file and during control, they are loaded and searched for coordinate values depending on the desired position. The selection of the most optimal motor coordinate values (q1,q2) is done so that the error is minimized.

![alt text](https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Lookup_table.png)

Namely, by entering the desired gripper position in the workspace, the environment around that point is checked. Then, when searching for a set of points in the vicinity, moves are drawn from the desired position to each point in the vicinity in order to determine the smallest move. The point that provides the smallest move is taken as the final position of the gripper tip. For that point, a combination of internal motor coordinates is taken, and based on that, the number of pulses and the direction of movement sent to the motor are determined. As we can see in the example, the desired position is determined by xH, yH. The algorithm draws moves r1...r4 to corresponding points 1...4 and then chooses the smallest move. Specifically in this case, that move is r3, and the point whose pair of internal coordinates provides that position is point 3. With this method, there is no need to form a sequence of sending matrices and paths, but the motors execute the final movement in 2 moves. Configuration selection and position checking are still done according to the previous algorithm. This type of solution is suitable for manipulation problems, but not for continuous movement or control of the direction of the robot's tip.

![alt text](https://github.com/dgladovic/Scara_Manipulator/blob/main/Assets/imgs/Lookup_Position.png)
