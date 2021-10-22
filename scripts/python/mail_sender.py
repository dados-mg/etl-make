import smtplib, os
from pathlib import Path
from dotenv import load_dotenv
load_dotenv(dotenv_path=Path('.', '.env'))

def send_mail():
  sender_email = "etl.age7.ckan@gmail.com"
  receiver_email = "gabrie.dornas@cge.mg.gov.com"
  message = "Mensagem de Erro"

  smtpserver = smtplib.SMTP("smtp.gmail.com", 587)
  smtpserver.ehlo()
  smtpserver.starttls()
  smtpserver.ehlo()
  smtpserver.login(sender_email, os.environ.get('MAIL_PASSWORD'))
  print("Login realizado com sucesso!")
  smtpserver.sendmail(sender_email, receiver_email, message)
  print("E-mail enviado com sucesso. Confira sua caixa de entrada")

send_mail()
