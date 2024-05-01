function csv_singolo = lettura_file(directory_csv)
%LETTURA_FILE Summary of this function goes here
%   Detailed explanation goes here

divisione_spazio = 800;


disp(directory_csv);
csv_singolo = readtable(strcat(directory_csv.folder, "\", directory_csv.name));
csv_singolo = removevars(csv_singolo, ["Frame_ID","Timestamp","Mano_ID","DX_SX"]);

directory_csv_split = split(directory_csv.folder, "\");
size_directory_csv_split = size(directory_csv_split); 
%Persona e nome file 
persona = {char(directory_csv_split(size_directory_csv_split(1)-3, 1))}; %da convertire a stringa
nome_file = {char(directory_csv.name)}; 

%Convertire in vettori 

informazioni_file = table(persona, nome_file); 

%Calcolarsi i dati per le dita

palm_frame = [csv_singolo.Palm_position_X, csv_singolo.Palm_position_Y, csv_singolo.Palm_position_Z];

palm_divisa = palm_frame/divisione_spazio; 

aritmetic_mean_palm = mean(palm_divisa); 
standard_deviation_palm = std(palm_divisa);
covariance_palm = cov(palm_divisa);
rms_palm = rms (palm_divisa);


%Mettere i dati calcolati nelle loro rispettive variabili 
aritmetic_mean_palm_x = aritmetic_mean_palm(1); 
aritmetic_mean_palm_y = aritmetic_mean_palm(2); 
aritmetic_mean_palm_z = aritmetic_mean_palm(3); 

standard_deviation_palm_x = standard_deviation_palm(1); 
standard_deviation_palm_y = standard_deviation_palm(2); 
standard_deviation_palm_z = standard_deviation_palm(3); 

%_XX posizione della matrice X e Y  
covariance_11_palm = covariance_palm(1,1); 
covariance_12_palm = covariance_palm(1,2); 
covariance_13_palm = covariance_palm(1,3); 
covariance_21_palm = covariance_palm(2,1); 
covariance_22_palm = covariance_palm(2,2); 
covariance_23_palm = covariance_palm(2,3); 
covariance_31_palm = covariance_palm(3,1); 
covariance_32_palm = covariance_palm(3,2); 
covariance_33_palm = covariance_palm(3,3); 

rms_palm_x = rms_palm(1); 
rms_palm_y = rms_palm(2); 
rms_palm_z = rms_palm(3); 

palm = table(aritmetic_mean_palm_x, aritmetic_mean_palm_y, aritmetic_mean_palm_z, standard_deviation_palm_x, standard_deviation_palm_y, standard_deviation_palm_z, covariance_11_palm, covariance_12_palm, covariance_13_palm, covariance_21_palm, covariance_22_palm, covariance_23_palm, covariance_31_palm, covariance_32_palm, covariance_33_palm, rms_palm_x, rms_palm_y, rms_palm_z);

%TO-DO Cambiare i nomi delle variabili per le variabili dei frame
%Thumb      
thumb_frame = [csv_singolo.Tip_position_Thumb_X, csv_singolo.Tip_position_Thumb_Y, csv_singolo.Tip_position_Thumb_Z];

thumb_divisa = thumb_frame/divisione_spazio; 

aritmetic_mean_thumb = mean(thumb_divisa); 
standard_deviation_thumb = std(thumb_divisa);
covariance_thumb = cov(thumb_divisa);
rms_thumb = rms (thumb_divisa);

%Calcolo dei dati Thumb
aritmetic_mean_thumb_x = aritmetic_mean_thumb(1); 
aritmetic_mean_thumb_y = aritmetic_mean_thumb(2); 
aritmetic_mean_thumb_z = aritmetic_mean_thumb(3); 

standard_deviation_thumb_x = standard_deviation_thumb(1); 
standard_deviation_thumb_y = standard_deviation_thumb(2); 
standard_deviation_thumb_z = standard_deviation_thumb(3); 

%_XX posizione della matrice X e Y  
covariance_11_thumb = covariance_thumb(1,1); 
covariance_12_thumb = covariance_thumb(1,2); 
covariance_13_thumb = covariance_thumb(1,3); 
covariance_21_thumb = covariance_thumb(2,1); 
covariance_22_thumb = covariance_thumb(2,2); 
covariance_23_thumb = covariance_thumb(2,3); 
covariance_31_thumb = covariance_thumb(3,1); 
covariance_32_thumb = covariance_thumb(3,2); 
covariance_33_thumb = covariance_thumb(3,3); 

rms_thumb_x = rms_thumb(1); 
rms_thumb_y = rms_thumb(2); 
rms_thumb_z = rms_thumb(3); 

thumb = table(aritmetic_mean_thumb_x, aritmetic_mean_thumb_y, aritmetic_mean_thumb_z, standard_deviation_thumb_x, standard_deviation_thumb_y, standard_deviation_thumb_z, covariance_11_thumb, covariance_12_thumb, covariance_13_thumb, covariance_21_thumb, covariance_22_thumb, covariance_23_thumb, covariance_31_thumb, covariance_32_thumb, covariance_33_thumb, rms_thumb_x, rms_thumb_y, rms_thumb_z);

%Index 
index_frame = [csv_singolo.Tip_position_Index_X, csv_singolo.Tip_position_Index_Y, csv_singolo.Tip_position_Index_Z];

index_divisa = index_frame/divisione_spazio; 

aritmetic_mean_index = mean(index_divisa); 
standard_deviation_index = std(index_divisa);
covariance_index = cov(index_divisa);
rms_index = rms (index_divisa);

%Calcolo dei dati index
aritmetic_mean_index_x = aritmetic_mean_index(1); 
aritmetic_mean_index_y = aritmetic_mean_index(2); 
aritmetic_mean_index_z = aritmetic_mean_index(3); 

standard_deviation_index_x = standard_deviation_index(1); 
standard_deviation_index_y = standard_deviation_index(2); 
standard_deviation_index_z = standard_deviation_index(3); 

%_XX posizione della matrice X e Y  
covariance_11_index = covariance_index(1,1); 
covariance_12_index = covariance_index(1,2); 
covariance_13_index = covariance_index(1,3); 
covariance_21_index = covariance_index(2,1); 
covariance_22_index = covariance_index(2,2); 
covariance_23_index = covariance_index(2,3); 
covariance_31_index = covariance_index(3,1); 
covariance_32_index = covariance_index(3,2); 
covariance_33_index = covariance_index(3,3); 

rms_index_x = rms_index(1); 
rms_index_y = rms_index(2); 
rms_index_z = rms_index(3); 

index = table(aritmetic_mean_index_x, aritmetic_mean_index_y, aritmetic_mean_index_z, standard_deviation_index_x, standard_deviation_index_y, standard_deviation_index_z, covariance_11_index, covariance_12_index, covariance_13_index, covariance_21_index, covariance_22_index, covariance_23_index, covariance_31_index, covariance_32_index, covariance_33_index, rms_index_x, rms_index_y, rms_index_z);

%Middle 

middle_frame = [csv_singolo.Tip_position_Middle_X, csv_singolo.Tip_position_Middle_Y, csv_singolo.Tip_position_Middle_Z];

middle_divisa = middle_frame/divisione_spazio; 

aritmetic_mean_middle = mean(middle_divisa); 
standard_deviation_middle = std(middle_divisa);
covariance_middle = cov(middle_divisa);
rms_middle = rms (middle_divisa);

%Calcolo dei dati middle
aritmetic_mean_middle_x = aritmetic_mean_middle(1); 
aritmetic_mean_middle_y = aritmetic_mean_middle(2); 
aritmetic_mean_middle_z = aritmetic_mean_middle(3); 

standard_deviation_middle_x = standard_deviation_middle(1); 
standard_deviation_middle_y = standard_deviation_middle(2); 
standard_deviation_middle_z = standard_deviation_middle(3); 

%_XX posizione della matrice X e Y  
covariance_11_middle = covariance_middle(1,1); 
covariance_12_middle = covariance_middle(1,2); 
covariance_13_middle = covariance_middle(1,3); 
covariance_21_middle = covariance_middle(2,1); 
covariance_22_middle = covariance_middle(2,2); 
covariance_23_middle = covariance_middle(2,3); 
covariance_31_middle = covariance_middle(3,1); 
covariance_32_middle = covariance_middle(3,2); 
covariance_33_middle = covariance_middle(3,3); 

rms_middle_x = rms_middle(1); 
rms_middle_y = rms_middle(2); 
rms_middle_z = rms_middle(3); 

middle = table(aritmetic_mean_middle_x, aritmetic_mean_middle_y, aritmetic_mean_middle_z, standard_deviation_middle_x, standard_deviation_middle_y, standard_deviation_middle_z, covariance_11_middle, covariance_12_middle, covariance_13_middle, covariance_21_middle, covariance_22_middle, covariance_23_middle, covariance_31_middle, covariance_32_middle, covariance_33_middle, rms_middle_x, rms_middle_y, rms_middle_z);

%Ring 

ring_frame = [csv_singolo.Tip_position_Ring_X, csv_singolo.Tip_position_Ring_Y, csv_singolo.Tip_position_Ring_Z];

ring_divisa = ring_frame/divisione_spazio; 

aritmetic_mean_ring = mean(ring_divisa); 
standard_deviation_ring = std(ring_divisa);
covariance_ring = cov(ring_divisa);
rms_ring = rms (ring_divisa);

%Calcolo dei dati ring
aritmetic_mean_ring_x = aritmetic_mean_ring(1); 
aritmetic_mean_ring_y = aritmetic_mean_ring(2); 
aritmetic_mean_ring_z = aritmetic_mean_ring(3); 

standard_deviation_ring_x = standard_deviation_ring(1); 
standard_deviation_ring_y = standard_deviation_ring(2); 
standard_deviation_ring_z = standard_deviation_ring(3); 

%_XX posizione della matrice X e Y  
covariance_11_ring = covariance_ring(1,1); 
covariance_12_ring = covariance_ring(1,2); 
covariance_13_ring = covariance_ring(1,3); 
covariance_21_ring = covariance_ring(2,1); 
covariance_22_ring = covariance_ring(2,2); 
covariance_23_ring = covariance_ring(2,3); 
covariance_31_ring = covariance_ring(3,1); 
covariance_32_ring = covariance_ring(3,2); 
covariance_33_ring = covariance_ring(3,3); 

rms_ring_x = rms_ring(1); 
rms_ring_y = rms_ring(2); 
rms_ring_z = rms_ring(3); 

ring = table(aritmetic_mean_ring_x, aritmetic_mean_ring_y, aritmetic_mean_ring_z, standard_deviation_ring_x, standard_deviation_ring_y, standard_deviation_ring_z, covariance_11_ring, covariance_12_ring, covariance_13_ring, covariance_21_ring, covariance_22_ring, covariance_23_ring, covariance_31_ring, covariance_32_ring, covariance_33_ring, rms_ring_x, rms_ring_y, rms_ring_z);

%Pinky 

pinky_frame = [csv_singolo.Tip_position_Pinky_X, csv_singolo.Tip_position_Pinky_Y, csv_singolo.Tip_position_Pinky_Z];

pinky_divisa = pinky_frame/divisione_spazio; 

aritmetic_mean_pinky = mean(pinky_divisa); 
standard_deviation_pinky = std(pinky_divisa);
covariance_pinky = cov(pinky_divisa);
rms_pinky = rms (pinky_divisa);

%Calcolo dei dati pinky
aritmetic_mean_pinky_x = aritmetic_mean_pinky(1); 
aritmetic_mean_pinky_y = aritmetic_mean_pinky(2); 
aritmetic_mean_pinky_z = aritmetic_mean_pinky(3); 

standard_deviation_pinky_x = standard_deviation_pinky(1); 
standard_deviation_pinky_y = standard_deviation_pinky(2); 
standard_deviation_pinky_z = standard_deviation_pinky(3); 

%_XX posizione della matrice X e Y  
covariance_11_pinky = covariance_pinky(1,1); 
covariance_12_pinky = covariance_pinky(1,2); 
covariance_13_pinky = covariance_pinky(1,3); 
covariance_21_pinky = covariance_pinky(2,1); 
covariance_22_pinky = covariance_pinky(2,2); 
covariance_23_pinky = covariance_pinky(2,3); 
covariance_31_pinky = covariance_pinky(3,1); 
covariance_32_pinky = covariance_pinky(3,2); 
covariance_33_pinky = covariance_pinky(3,3); 

rms_pinky_x = rms_pinky(1); 
rms_pinky_y = rms_pinky(2); 
rms_pinky_z = rms_pinky(3); 

pinky = table(aritmetic_mean_pinky_x, aritmetic_mean_pinky_y, aritmetic_mean_pinky_z, standard_deviation_pinky_x, standard_deviation_pinky_y, standard_deviation_pinky_z, covariance_11_pinky, covariance_12_pinky, covariance_13_pinky, covariance_21_pinky, covariance_22_pinky, covariance_23_pinky, covariance_31_pinky, covariance_32_pinky, covariance_33_pinky, rms_pinky_x, rms_pinky_y, rms_pinky_z);

lettere_dataset = {char(directory_csv_split(size_directory_csv_split(1), 1))}; %

%Export dei dati calcolati 
csv_singolo1 = [informazioni_file,palm, thumb, index, middle, ring, pinky, lettere_dataset]; 
csv_singolo = renamevars(csv_singolo1, "Var111", "lettere_dataset"); 

end

