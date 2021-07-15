clear;clc;



joints = ["shoulder", "shoulder", "shoulder", "elbow", "ulnar_radial", "wrist", "wrist"]; 
coordinates = ["shoulder_adduction", "shoulder_rotation", "shoulder_flexion", "elbow_flexion", "radial_pronation", "wrist_flexion", "wrist_abduction"];



for i=1:7
    fprintf("/jointset/%s/%s/value\t", joints(i), coordinates(i));
end