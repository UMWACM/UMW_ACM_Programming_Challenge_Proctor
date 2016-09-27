# see https://thinkincredible.intraway.com/2016/02/05/implementing-python-telnet-server-testing-development/
from telnetsrv.threaded import TelnetHandler
import SocketServer

class TelnetServer(SocketServer.TCPServer):
    allow_reuse_address = True

class OurHandler(TelnetHandler):
    def cmdHELP(self, params):
        self.writeresponse("""
This is the UMW ACM bi-weekly programming challenge server.

Commands
  help
    print this help text
  submit team_name email@address hex_id_123  [--hints]
     
""")
    
    def cmdVERSION(self, params):
        self.writeresponse("v1.0")
    
server = 0
try:
    server = TelnetServer(("localhost", 23), OurHandler)
except:
    print("Switching to port 2323 (You're probably a developer if you broke this)")
    server = TelnetServer(("localhost", 2323), OurHandler)
    
try:
    server.serve_forever()
except KeyboardInterrupt:
    print("Exiting telnet server")


