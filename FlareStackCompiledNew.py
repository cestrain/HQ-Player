#GPIO Imports
import os
import RPi.GPIO as GPIO	#import GPIO module
import pigpio # http://abyz.co.uk/rpi/pigpio/python.html for Temp Sensor Code


###Timer Import
import time
from threading import Timer
##from time import sleep
from RepeatingTimerFile import RepeatingTimer


#GPIO Setup
valve_pin = 19
spark_pin = 13

#GPIO.cleanup()
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)      #BCM uses Broadcom pin numbering
GPIO.setup(valve_pin,GPIO.OUT)     #define valve pin as output pin
GPIO.setup(spark_pin,GPIO.OUT)     #define spark pin as output pin
p = GPIO.PWM(spark_pin, 1) #set pwm for spark
p.start(0)#start pwm at zero DC so essentially off


#####Global Variables######
temp_prev=-100000#Previous Temperature
temp_curr=0 #Current Temperature
ignition_status = 0 #0 if igniting, 1 if not
check_lit_variable=0 #Dummy variable for the check lit cancel command
ignition_timer_variable=0 #Dummy variable for the ignition timer cancel command
not_lit=0

#####Variables to Change#####
lit_tolerance=3 #Decides the difference to be consdered lit
extinguish_tolerance=10 #Decides the difference to be consdered extingusihed
ignition_time=15 #Decides how long to run the ignition sequence
checking_lit_time=10#Decides how long between lit checks


######Timer Setup######
def failed_ignition():
    global valve  #Enable Editability of Global Variables
    valve = 0   #Change global variable so that if condition in while loop is not met, preventing the ignition sequencce from starting again
    filewriter=open("valvestat.txt","w")#Overwriting the file to prevent it being reverted back in the reading in the while loop
    filewriter.write("0")
    filewriter.close()
    print("1 Minute Lapsed, No ignition, Valve closed")

    close_valve()
    stop_ignition()
    global ignition_timer_variable
    ignition_timer_variable=1
    
    
    pi.spi_close(sensor)#Turning off the thermocouple
    pi.stop()

def check_if_still_lit():
    global temp_prev
    global temp_curr
    print("Previous Temp:")
    print(temp_prev)
    print("Current Temp:")
    print(temp_curr)
    if temp_curr<(temp_prev-extinguish_tolerance):    #The current temp is 20deg less than the recorded Flame Temp 120 sec ago indicating that the flare stack is not lit
        print("Not Lit")
        global ignition_status
        ignition_status=0   #Change Global Ignition Status to zero which will allow temp increase check in valve while loop to be run
        global not_lit
        not_lit=1
        #start_ignition()
        #ignition_timer.start()
        
    temp_prev=temp_curr  #Save the current temp to be compared against in next iteration
##Timer Definitions
ignition_timer = RepeatingTimer(ignition_time, failed_ignition)
check_lit_timer = RepeatingTimer(checking_lit_time, check_if_still_lit)



######Function Definitions#####
def start_ignition():
    global p
    p.ChangeDutyCycle(50)#start pwm
    #GPIO.output(spark_pin,GPIO.HIGH)
    print("Ignition Started")

def stop_ignition():

    global p
    p.ChangeDutyCycle(0)#stop pwm
    #GPIO.output(spark_pin,GPIO.LOW)
    
    print("Ignition Stoped")

def open_valve():
    
    GPIO.output(valve_pin,GPIO.HIGH)
    print("Valve Open")
    
def close_valve():
    
    GPIO.output(valve_pin,GPIO.LOW)
    print("Valve Closed")


pi = pigpio.pi()#Neccessary Preamble for the thermocouple

if not pi.connected:
   exit(0)


######Infinite While Loop "Main Code"#######

while 1:
    valvefile=open("valvestat.txt", "r")#Checking the valve remote status
    valve=float(valvefile.read())

    if valve == 1:   #Global Variable Changed in the shell, initiates ignition sequence
        open_valve()        
        print ("Valve Open")

        ###########Downloaded Temp Sense Code  ##################################
        sensor = pi.spi_open(1, 1000000, 0) # CE1 on SPI

        c, d = pi.spi_read(sensor, 2)
        if c == 2:
            word = (d[0]<<8) | d[1]
            if (word & 0x8006) == 0: # Bits 15, 2, and 1 should be zero.
                 t = (word >> 3)/4.0
                 print("{:.2f}".format(t))
                 temp_prev=int(t) #Read the Current Temperature
                 
            else:
                print("bad reading {:b}".format(word))
        time.sleep(0.25) # Don't try to read more often than 4 times a second.
        #################################################################   
        
        start_ignition()
        ignition_timer.start()

        
        while valve == 1:  #Remain here until ignition fails then valve will be closed
            valvefile=open("valvestat.txt", "r")#Checking the valve remote status once more
            valve=float(valvefile.read())

            ########### Read Current Temp ################################
            c, d = pi.spi_read(sensor, 2)
            if c == 2:
                word = (d[0]<<8) | d[1]
                if (word & 0x8006) == 0: # Bits 15, 2, and 1 should be zero.
                     t = (word >> 3)/4.0
                     print("{:.2f}".format(t))
                     temp_curr=int(t)
                else:
                    print("bad reading {:b}".format(word))
            time.sleep(0.25) # Don't try to read more often than 4 times a second.
            ###############################################################

         

            
            if ignition_status == 0:
                
                if check_lit_variable==1:
                    check_lit_timer.cancel()
                    print("Check Lit Timer Stoped")
                    check_lit_variable=0
                if ignition_timer_variable==1:
                    ignition_timer.cancel()
                    print("Ignition Timer Stoped")
                    ignition_timer_variable=0
                if not_lit==1:
                    start_ignition()
                    ignition_timer.start()
                    not_lit=0                    
                if temp_curr > temp_prev + lit_tolerance: #If the current temp is 20deg > than the previous temp then the flare stack is lit
                    ignition_status = 1   #Flare stack is lit so no longer compare current temp to initial temp. Return to valve while loop
                    stop_ignition()
                    temp_prev = temp_curr
                    print("Ignition succesfull, spark plug turned off")
                    ignition_timer.cancel() #Stop failed ignition timer as ignition has occured within time limit
                    check_lit_timer.start()  #Start timer that checks every 2 minutes if the flame is lit
                    check_lit_variable=1

    else:
        close_valve()
        if check_lit_variable==1:
            check_lit_timer.cancel()
        
