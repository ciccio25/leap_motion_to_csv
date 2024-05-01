%Lettura delle sottocartelle
%Produzione di un unico csv con media aritmetica, deviazione standard e rms
%di Palm, Thumb, Index, Middle, Ring, Pinky 
%MATLAB 2024a Windows 10
clear all; 

csv_totali_dataset = size(dir("Dataset\Lettere_LIS\**\*.csv"), 1); 

csv_totali_dataset_lista = dir("Dataset\Lettere_LIS\**\*.csv"); 

lettere_cartelle = dir("Dataset\Lettere_LIS\*"); 

%tabella = creazione_tabella_dataset(csv_totali_dataset);
%tabella2 = creazione_tabella_dataset(csv_totali_dataset);

tabella = 0; 

%TO-DO fare funzione che crei una sottotabella della cartella
%Ogni csv dei 120 frame --> 1 riga della tabella

for i=1:size(csv_totali_dataset_lista)

    if(i ==1)
        tabella = lettura_file(csv_totali_dataset_lista(i)); 
    else 
        
        tabella_frame = lettura_file(csv_totali_dataset_lista(i));
        tabella = [tabella; tabella_frame]; 

    end

    %tabella_frame = lettura_file(csv_totali_dataset_lista(i)); 
    %tabella = [tabella; tabella_frame];
    disp(csv_totali_dataset_lista(i).name);

    %Aggiungere tabella_frame nella mega tabellona
    
end

%Loop contatore che deve inziare da 2

%Da aggiungere 

%Lista delle variabili nella tabella 


%{

directory_dataset_lettere = dir("Dataset\Lettere_LIS\*");
%mettere un loop che guarda ogni cartella, con contatore che parte da 3 e
%finisce al numero massimo di cartelle 
lista_csv_lettera = dir(strcat(directory_dataset_lettere(3).folder,"\", directory_dataset_lettere(3).name, "\*.csv" )); 

%loop per la lettura dei file 
file_frame = strcat(lista_csv_lettera(1).folder,"\", lista_csv_lettera(1).name); 
disp(file_frame); 
tabella_frame = readtable(file_frame); 

tabella_frame = removevars(tabella_frame, ["Frame_ID","Timestamp","Mano_ID","DX_SX"]);

%Lista delle colonne di Palm, Thumb, Index, Middle, Ring, Pinky e calcolo
%dei suoi valori 

matrice_palm = [tabella_frame.Palm_position_X, tabella_frame.Palm_position_Y, tabella_frame.Hand_direction_Z]; 

%Dividere per un fattore in modo che i valori siano tra [-1,1] 
%https://discord.com/channels/994213697490800670/1226542385895440518
% Distanza massima Leap Motion 80cm=800mm in cui 1.0 valore = 1mm nella
% realtà 
divisione_spazio = 800; 

matrice_palm_divisa = matrice_palm/divisione_spazio; 

media_aritmetica_palm = mean(matrice_palm_divisa); 
deviazione_standard_palm = std(matrice_palm_divisa);
RMS_palm = rms (matrice_palm_divisa);
covarianza = cov(matrice_palm_divisa);



%Aggiungere la colonna prima di aggiungere 
cartella_lettera = strsplit(lista_csv_lettera(1).folder, "\"); 

lettera = char(cartella_lettera(size(cartella_lettera, 2))); 

vettore_lettera = char(ones(height(tabella_frame),1)*lettera); 


colonna_lettera = table(vettore_lettera); 

tabella_frame = [tabella_frame, colonna_lettera]; 

%}


%Nome file = Nome persona + data e ore creazione dataset+ "DATASET".csv 

%nome_persona = dir(); 
%nome_persona = nome_persona(1).folder; 
%nome_persona = split(nome_persona, "\"); 
%nome_persona = nome_persona(size(nome_persona), 1); 
%nome_persona = nome_persona(1,1); 

%disp(nome_persona); 

%nome_file = strcat(nome_persona, "-", string(datetime), "-DATASET.csv"); 
%nome_file = strcat(string(datetime), "-dataset_finale.csv"); 

%vedere nome_file cosa è 

writetable(tabella, "dataset_finale.csv"); 
