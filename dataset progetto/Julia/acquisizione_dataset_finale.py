import csv
import leap
import numpy as np
import cv2

from cffi import FFI
from enum import Enum

from datetime import datetime 
from PIL import Image
import time

'''
Obbiettivo del progetto: 
salvare 120 frame dal Leap Motion, in modo da creare un dataset delle mani per futuri scopi
(1 csv, 1 foto del frame iniziale, 1 foto del frame finale)

Software scritto da Stefano Rossini 

'''

class Side(Enum):
    Left = 0
    Right = 1

_TRACKING_MODES = {
    leap.TrackingMode.Desktop: "Desktop",
    leap.TrackingMode.HMD: "HMD",
    leap.TrackingMode.ScreenTop: "ScreenTop",
}

_CAMERA_SIDE = {
    Side.Left: "Left",
    Side.Right: "Right"
}

#Valori iniziali da impostare 

frame_iniziale = None

# Media del dataset LeapGestureDB = 120 https://sites.google.com/view/leapmotiondatabase/accueil 

frame_finale = 120  

frame_attuale = None

flag_lettura_file = None

#Directory in cui si andranno a salvare i file 
file_name = "Dataset" 

#Scelta dove salvare il file 
input_tipo_dataset = int(input("Quale dataset vuoi registrate?\nDigita 1 per Gesti IEEE\nDigita 2 per Lettere ASL\n"))

if input_tipo_dataset == 1:
    file_name = file_name + "/Gesti_IEEE"
    print("\n")
    cartella = int(input("1 Click\n2 Left Rotation\n3 Right rotation\n8 Move left\n9 Move right\10 Previous\n11 Next\n"))
    if cartella == 1:
        file_name = file_name + "/1-Click"
    if cartella == 2:
        file_name = file_name + "/2-Left_Rotation"
    if cartella == 3:
        file_name = file_name + "/3-Right_rotation"
    if cartella == 8:
        file_name = file_name + "/8-Move_left"
    if cartella == 9:
        file_name = file_name + "/9-Move_right"
    if cartella == 10:
        file_name = file_name + "/10-Previous"
    if cartella == 11:
        file_name = file_name + "/11-Next"

     
                
elif input_tipo_dataset == 2: 
        file_name = file_name + "/Lettere_LIS"
        print("\n")
        cartella = str(input("Scrivi la lettera che vuoi registrare\n")).upper()
        file_name = file_name + "/" + cartella 
    

file_name = file_name + "/"+ datetime.now().strftime('%d-%m-%Y-%H-%M-%S')

file_name_csv = file_name + ".csv"

print("\nLa directory si troverà in: " + file_name_csv + "\n")

#Inizio creazione csv 


header_tabella = [    "Frame_ID",             "Timestamp",            "Mano_ID",        "DX_SX",              
                      "Hand_direction_X",     "Hand_direction_Y",     "Hand_direction_Z", 
                      "Palm_position_X",      "Palm_position_Y",      "Palm_position_Z",
                      "Palm_normal_X",        "Palm_normal_Y",        "Palm_normal_Z", 
                      "Tip_positon_Thumb X",  "Tip_positon_Thumb_Y",  "Tip_positon_Thumb_Z",
                      "Tip_positon_Index_X",  "Tip_positon_Index_Y",  "Tip_positon_Index_Z", 
                      "Tip_positon_Middle_X", "Tip_positon_Middle_Y", "Tip_positon_Middle_Z",
                      "Tip_positon_Ring_X",   "Tip_positon_Ring_Y",   "Tip_positon_Ring_Z",
                      "Tip_positon_Pinky_X",  "Tip_positon_Pinky_Y",  "Tip_positon_Pinky_Z"]

file = open(file_name_csv, 'w', newline='') 
writer = csv.writer(file)
writer.writerow(header_tabella)


#Configurazione del Visualizer dall'example visualizer.py 
class Canvas:
    def __init__(self):
        
        #Nome della finestra dal Leap Motion e la sua dimensione in pixel 
        self.name = "Python Gemini Visualiser - Creazione Dataset"
        self.screen_size = [500, 700]

        self.hands_colour = (255, 255, 255)
        self.font_colour = (0, 255, 44)
        self.hands_format = "Skeleton"
        self.output_image = np.zeros((self.screen_size[0], self.screen_size[1], 3), np.uint8)
        self.tracking_mode = None

        # For images management
        self.image = np.zeros((self.screen_size[0], self.screen_size[1], 3), np.uint8)
        self.displayed_side = Side.Left

    def set_tracking_mode(self, tracking_mode):
        self.tracking_mode = tracking_mode

    def toggle_hands_format(self):
        self.hands_format = "Dots" if self.hands_format == "Skeleton" else "Skeleton"
        print(f"Set hands format to {self.hands_format}")

    def switch_view(self):
        self.displayed_side = Side.Right if self.displayed_side is Side.Left else Side.Left

    def get_joint_position(self, bone):
        if bone:
            return int(bone.x + (self.screen_size[1] / 2)), int(bone.z + (self.screen_size[0] / 2))
        else:
            return None

    def render_hands(self, event):
        # Clear the previous image
        self.output_image[:, :] = cv2.resize(self.image, dsize=(self.screen_size[1], self.screen_size[0]), interpolation=cv2.INTER_CUBIC)

        cv2.putText(
            self.output_image,
            f"Tracking Mode: {_TRACKING_MODES[self.tracking_mode]}",
            (10, self.screen_size[0] - 10),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.5,
            self.font_colour,
            1,
        )

        cv2.putText(
            self.output_image,
            f"Camera: {_CAMERA_SIDE[self.displayed_side]}",
            (10, self.screen_size[0] - 30),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.5,
            self.font_colour,
            1
        )

        if len(event.hands) == 0:
            return

        for i in range(0, len(event.hands)):
            hand = event.hands[i]
            for index_digit in range(0, 5):
                digit = hand.digits[index_digit]
                for index_bone in range(0, 4):
                    bone = digit.bones[index_bone]
                    if self.hands_format == "Dots":
                        prev_joint = self.get_joint_position(bone.prev_joint)
                        next_joint = self.get_joint_position(bone.next_joint)
                        if prev_joint:
                            cv2.circle(self.output_image, prev_joint, 2, self.hands_colour, -1)

                        if next_joint:
                            cv2.circle(self.output_image, next_joint, 2, self.hands_colour, -1)

                    if self.hands_format == "Skeleton":
                        wrist = self.get_joint_position(hand.arm.next_joint)
                        elbow = self.get_joint_position(hand.arm.prev_joint)
                        if wrist:
                            cv2.circle(self.output_image, wrist, 3, self.hands_colour, -1)

                        if elbow:
                            cv2.circle(self.output_image, elbow, 3, self.hands_colour, -1)

                        if wrist and elbow:
                            cv2.line(self.output_image, wrist, elbow, self.hands_colour, 2)

                        bone_start = self.get_joint_position(bone.prev_joint)
                        bone_end = self.get_joint_position(bone.next_joint)

                        if bone_start:
                            cv2.circle(self.output_image, bone_start, 3, self.hands_colour, -1)

                        if bone_end:
                            cv2.circle(self.output_image, bone_end, 3, self.hands_colour, -1)

                        if bone_start and bone_end:
                            cv2.line(self.output_image, bone_start, bone_end, self.hands_colour, 2)

                        if ((index_digit == 0) and (index_bone == 0)) or (
                            (index_digit > 0) and (index_digit < 4) and (index_bone < 2)
                        ):
                            index_digit_next = index_digit + 1
                            digit_next = hand.digits[index_digit_next]
                            bone_next = digit_next.bones[index_bone]
                            bone_next_start = self.get_joint_position(bone_next.prev_joint)
                            if bone_start and bone_next_start:
                                cv2.line(
                                    self.output_image,
                                    bone_start,
                                    bone_next_start,
                                    self.hands_colour,
                                    2,
                                )

                        if index_bone == 0 and bone_start and wrist:
                            cv2.line(self.output_image, bone_start, wrist, self.hands_colour, 2)


class TrackingListener(leap.Listener):
    def __init__(self, canvas):
        self.canvas = canvas
        self.ffi = FFI()

    def on_connection_event(self, event):
        pass

    def on_tracking_mode_event(self, event):
        self.canvas.set_tracking_mode(event.current_tracking_mode)
        print(f"Tracking mode changed to {_TRACKING_MODES[event.current_tracking_mode]}")

    def on_device_event(self, event):
        try:
            with event.device.open():
                info = event.device.get_info()
        except leap.LeapCannotOpenDeviceError:
            info = event.device.get_info()

        print(f"Found device {info.serial}")

    def on_tracking_event(self, event):
        self.canvas.render_hands(event)

        #Importa i valori globali, in modo da usarli e modificarli  
        global frame_iniziale 
        global frame_finale
        global frame_attuale 
        global flag_lettura_file
        global file 
        
        frame_attuale = event.tracking_frame_id
        
        #Se il Leap Motion riconosce delle mani, si svolgono le istruzioni all'interno del ciclo for 
        for hand in event.hands:
            
            #Hand type 1 --> Mano Destra
            #Hand type 2 --> Mano Sinistra
            
            hand_type = 2 if str(hand.type) == "HandType.Left" else 1
            
            if hand_type == 1: 
                print("Mano destra visibile e riconosciuta \n")
            else:  
                print("Mano sinistra visibile e riconosciuta \n")


            
            if frame_iniziale == None:
                    frame_iniziale = frame_attuale
                
                    frame_finale = frame_iniziale + frame_finale 

                    flag_lettura_file = True

            if flag_lettura_file == True:
                
                #Acqusizione dei dati dal frame  

                vettore_dati_frame = [str(frame_attuale), str(event.timestamp), str(hand.id), str(hand_type), 
                                          str(hand.palm.direction.x), str(hand.palm.direction.y), str(hand.palm.direction.z), 
                                          str(hand.palm.position.x), str(hand.palm.position.y), str(hand.palm.position.z), 
                                          str(hand.palm.normal.x), str(hand.palm.normal.y), str(hand.palm.normal.z), 
                                          str(hand.digits[0].bones[3].next_joint.x), str(hand.digits[0].bones[3].next_joint.y), str(hand.digits[0].bones[3].next_joint.z),
                                          str(hand.digits[1].bones[3].next_joint.x), str(hand.digits[1].bones[3].next_joint.y), str(hand.digits[1].bones[3].next_joint.z),
                                          str(hand.digits[2].bones[3].next_joint.x), str(hand.digits[2].bones[3].next_joint.y), str(hand.digits[2].bones[3].next_joint.z),
                                          str(hand.digits[3].bones[3].next_joint.x), str(hand.digits[3].bones[3].next_joint.y), str(hand.digits[3].bones[3].next_joint.z),
                                          str(hand.digits[4].bones[3].next_joint.x), str(hand.digits[4].bones[3].next_joint.y), str(hand.digits[4].bones[3].next_joint.z) 
                                        ]
                    
                    
                #Scrittura dei dati sul csv
                writer.writerow(vettore_dati_frame)

                 
                
                

            
   
        if frame_attuale == frame_finale: 
            #print(f"Fine acquisizione Leap Motion mani")
            flag_lettura_file = False

    

    def on_image_event(self, event):
        index = 0 if self.canvas.displayed_side is Side.Left else 1

        properties = event.image[index].c_data.properties
        offset = event.image[index].c_data.offset
        height = properties.height
        width = properties.width

        # I'm sure it can be improved. Not feeling comfy managing pointers in Python
        image_ptr = self.ffi.cast("int *", event.image[index].c_data.data + offset)
        ffi_buffer = self.ffi.buffer(image_ptr, height * width)
        np_buffer = np.flip(np.frombuffer(ffi_buffer, dtype=np.uint8).reshape((height, width)), 1)
        
        #Da NumPy array a immagine: decommentare se si vuole salvare ogni immagine che il Leap Motion riconosce 
        #im = Image.fromarray(np_buffer)
        #im.save(file_name + str(datetime.now().strftime('%d-%m-%Y-%H-%M-%S')) + ".jpeg")
        
        self.canvas.image = np.repeat(np_buffer[:, :, np.newaxis], 3, axis=2)


def main():
    canvas = Canvas()

    print(canvas.name)
    
    '''
    print("")
    print("Press <key> in visualiser window to:")
    print("  x: Exit")
    print("  h: Select HMD tracking mode")
    print("  s: Select ScreenTop tracking mode")
    print("  d: Select Desktop tracking mode")
    print("  f: Toggle hands format between Skeleton/Dots")
    print("  g: Switch between right and left view")

    '''
    
    
    
    tracking_listener = TrackingListener(canvas)

    connection = leap.Connection()
    connection.add_listener(tracking_listener)

    running = True

    with connection.open():
        connection.set_tracking_mode(leap.TrackingMode.Desktop)
        canvas.set_tracking_mode(leap.TrackingMode.Desktop)
        connection.set_policy_flags([leap.PolicyFlag.Images], [])

        #Flag per indicare se è la prima volta che il Leap Motion riconosce delle mani/o
        #Vero se ancora non è riconosciuto, Falso se è stato riconosciuto almeno una volta
        status = True

        while running:

            #Finestre per mostrare la foto reference e lo stream video dal Leap Motion
            #cv2.imshow("Foto reference", cv2.imread(r"Dataset/lingua-dei-segni-italiana.jpg"))
            cv2.imshow("Foto reference", cv2.imread(r"Dataset/File_IEEE_Movimento_piccolo.png"))
            cv2.imshow(canvas.name, canvas.output_image)
            
            
            key = cv2.waitKey(1)
            
            '''
            if key == ord("x"):
                break
            elif key == ord("h"):
                connection.set_tracking_mode(leap.TrackingMode.HMD)
            elif key == ord("s"):
                connection.set_tracking_mode(leap.TrackingMode.ScreenTop)
            elif key == ord("d"):
                connection.set_tracking_mode(leap.TrackingMode.Desktop)
            elif key == ord("f"):
                canvas.toggle_hands_format()
            elif key == ord("g"):
                canvas.switch_view()

            '''
            
            
            if flag_lettura_file == False: 
                running = flag_lettura_file  

            if flag_lettura_file == True & status ==True:
                #Se è la prima volta che il Leap Motion riconosce delle mani/o, si salva la foto iniziale
                im = Image.fromarray(canvas.output_image)
                im.save(file_name + "-start.jpeg")   
                print("Foto inziale salvata")
                status = False
                 
                            
                    
    #Se è l'ultima volta che il Leap Motion riconosce delle mani/o, si salva la foto finale         
    im = Image.fromarray(canvas.output_image)
    im.save(file_name + "-end.jpeg")
    print("Foto finale salvata\n")

    #Distrugge le finestre che mostrano la foto reference e lo stream video dal Leap Motion
    cv2.destroyAllWindows()
    print("Fine Acquisizione Leap Motion\n")


if __name__ == "__main__":
    main()
