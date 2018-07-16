#Author :Kudzai Simau
#Project :TIA Power Utility
#Prof AGEE
from Tkinter import *
from tkMessageBox import *
import  pymysql
import matplotlib
matplotlib.use("TkAgg")
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg,NavigationToolbar2TkAgg
from matplotlib.figure import Figure
import matplotlib.animation as animation
from matplotlib import style
style.use("ggplot")

hostname='localhost'
username='root'
password='Kudzai8'
database='Test_101'


class StartUpPage(Frame):
    """This is the initial start up page"""

    def __init__(self):
        """This method creates and puts widgets onto the start up page(login page)"""
        self.username= " "
        self.password=" "
        Frame.__init__(self)
        self.master.title("Start Up Page")
        self.master.rowconfigure( 0, weight = 1 )
        self.master.columnconfigure( 0, weight = 1 )
        self.grid( sticky = W+E+N+S )
    
        self.label0=Label(self,text="LOGIN " )
        self.label0.grid(row=1,column=6,sticky=W+E+N+S)
        
        self.label1=Label(self,text="Username",width=30)
        self.label1.grid(row=2,column=5,sticky=W)
        
        self.label2=Label(self,text="Password",width=30)
        self.label2.grid(row=3,column=5,sticky=W)
        
        self.entry1=Entry(self,name="username",width=40)
        self.entry1.grid(row=2,column=6)
        self.entry2=Entry(self,name="password",show="*",width=40)
        self.entry2.grid(row=3,column=6)
        self.master.geometry("600x600")
        
        self.entry1.bind("<Return>",self.getUserName)
        self.entry2.bind("<Return>",self.getPassword)        
        self.variable1=BooleanVar()
        self.variable2=BooleanVar()
        
        self.KeepLogIn=Checkbutton(self,text="Remember Login",variable=self.variable1,command=self.SaveLogin)
        self.ShowPassword=Checkbutton(self,text="Show Password",variable=self.variable2)
            #,command=self.CheckPassword)
        self.KeepLogIn.grid(row =4)
        self.ShowPassword.grid(row=5)

        self.master.rowconfigure(1,weight=1)
        self.master.columnconfigure(1,weight=1)
        self.button=Button(self,text="Login",command=self.Login)
        self.button.grid( row =4 ,column=5,rowspan=2)

    def Login(self):
        if self.doQuery():
            self.grid_forget()
            EnergyMeterControl().mainloop()
        else:
            showinfo("Wrong UserName or Password  Please Login Again")

    def getUserName(self,event):
        self.username=event.widget.get()
        showinfo(self.username)

    def getPassword(self,event):
        self.password=event.widget.get()
        showinfo(self.password)

    def doQuery(self):
        conn=pymysql.connect(host=hostname,user=username,passwd=password,db=database)
        cur=conn.cursor()
        cur.execute("SELECT  username,password FROM  Employees")
        for usernm,passwrd in cur.fetchall():
            if self.username==usernm:
                if  self.password==passwrd:
                    conn.close()
                    return 1
        conn.close()
        return 0
       

    def SaveLogin(self):
        self.entry1.insert(INSERT,self.username)
        self.entry2.insert(INSERT,self.password)

    #def CheckPassword(self):
       
class EnergyMeterControl(Frame):
    """this is the energy meter controll page which allows the user to  charge customers and view spending patterns"""
    def __init__(self):
        """this method initializes the energy meter control frame """

        self.aListX=[]
        self.aListY=[]
        Frame.__init__(self)
        self.master.title("Meter Control Page")
        #EnergyMeterControl().mainloop()
        self.master.rowconfigure( 0, weight = 1 )
        self.master.columnconfigure( 0, weight = 1 )
        self.grid( sticky = W+E+N+S )
        self.master.geometry("600x620")

        self.label=Label(self,text="Total  Power Being Used")
        self.label.grid(column=0,row=0)

        self.power=Entry(self,name="powerValues",width=40)
        self.power.config(state=DISABLED)
        self.power.grid(column=1,row=0)

    
        self.label1=Label(self,text="Cost Per/KWH")
        self.label1.grid(row=1,column=0)
        self.Cost=Entry(self,name="cost",width=40)
        self.Cost.grid(column=1,row=1)
        self.Cost.config(state=DISABLED)

        self.button1=Button(self,text="Change Cost")
         #,command=Change_Cost)
        self.button1.grid(column=3,row=1)

        #this is the change cost frame
        
        #def Change_Cost():
        self.logout=Button(self,text="Logout",command=self.Logout)
        self.logout.grid(column=6,row=8)
        #self.canvas1=Canvas(self)
        #self.canvas1.grid(row=9,columnspan=6)
        self.GetValues()
        f=Figure(figsize=(5,5),dpi=100)
        a=f.add_subplot(111)
        a.plot(self.aListX,self.aListY)
        self.canvas1=FigureCanvasTkAgg(f,self)
        self.canvas1.show()
        self.canvas1.get_tk_widget().grid(column=1,row=9,columnspan=5)

               

    def Logout(self):
        self.grid_forget()
        StartUpPage().mainloop()

    def GetValues(self):
        conn=pymysql.connect(host=hostname,user=username,passwd=password,db=database)
        cur=conn.cursor()
        cur.execute("SELECT  CustomerNumber,powerSpent  FROM Customers")
        for x,y in cur.fetchall():
            self.aListX.append(x)
            self.aListY.append(y)
        conn.close()
        return 0


def main():
   StartUpPage().mainloop()
   #EnergyMeterControl().mainloop()


if __name__=="__main__":
    main()


