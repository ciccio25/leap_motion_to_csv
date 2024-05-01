%Script da usare per rinominare i file nelle colonne con il giusto nome
clear all; 
lista_file = dir("*\*\*\*.csv"); 
for i = 1: size(lista_file)
    file_path_csv = strcat(lista_file(i).folder, "\", lista_file(i).name);
    tabella = readtable(file_path_csv); 
    %Rinominare le colonne 
    colonne_nominate = ["Tip_positon_ThumbX",  "Tip_positon_Thumb_Y",  "Tip_positon_Thumb_Z", "Tip_positon_Index_X",  "Tip_positon_Index_Y",  "Tip_positon_Index_Z", "Tip_positon_Middle_X", "Tip_positon_Middle_Y", "Tip_positon_Middle_Z", "Tip_positon_Ring_X",   "Tip_positon_Ring_Y",   "Tip_positon_Ring_Z", "Tip_positon_Pinky_X",  "Tip_positon_Pinky_Y",  "Tip_positon_Pinky_Z"]; 
    colonne_da_nominare = ["Tip_position_Thumb_X",  "Tip_position_Thumb_Y",  "Tip_position_Thumb_Z", "Tip_position_Index_X",  "Tip_position_Index_Y",  "Tip_position_Index_Z", "Tip_position_Middle_X", "Tip_position_Middle_Y", "Tip_position_Middle_Z", "Tip_position_Ring_X",   "Tip_position_Ring_Y",   "Tip_position_Ring_Z", "Tip_position_Pinky_X",  "Tip_position_Pinky_Y",  "Tip_position_Pinky_Z"]; 
    
    tabella_da_rinominare = renamevars(tabella, colonne_nominate, colonne_da_nominare); 
    writetable(tabella_da_rinominare, file_path_csv); 

    disp(file_path_csv); 
end