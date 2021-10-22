import smtplib, os
import json
from pathlib import Path
from dotenv import load_dotenv
load_dotenv(dotenv_path=Path('.', '.env'))

def check_log_erros():
  if validate_erros_look_up():
    send_mail()
  else:
    print('Nenhum erro detectado durante carga')

def send_mail():
  sender_email = "etl.age7.ckan@gmail.com"
  # receiver_email = "gabriel.dornas@cge.mg.gov.br"
  receiver_email = "gabrielbdornas@gmail.com"
  message = "Problema com a carga. Check os logs"
  smtpserver = smtplib.SMTP("smtp.gmail.com", 587)
  smtpserver.ehlo()
  smtpserver.starttls()
  smtpserver.ehlo()
  smtpserver.login(sender_email, os.environ.get('MAIL_PASSWORD'))
  print("Login realizado com sucesso!")
  smtpserver.sendmail(sender_email, receiver_email, message)
  print("E-mail enviado com sucesso. Confira sua caixa de entrada")

def validate_erros_look_up():
  any_errors = False
  path = 'logs/validate/'
  folder = os.fsencode(path)
  for file in os.listdir(folder):
    filename = os.fsdecode(file)
    file = open(f'{path}{filename}', "r").read()
    validation = json.loads(file)
    if validation["valid"] == False:
      any_errors = True
  return any_errors

if __name__ == "__main__":
  check_log_erros()
