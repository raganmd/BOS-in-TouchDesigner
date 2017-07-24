import webbrowser

class learningGlsl:
	def __init__(self):
		return
	
	def OpenLink(self, URL):
		webbrowser.open_new(URL)
		return
	
	def CloseBOS(self, prompt=True):
		project.quit( force=prompt, crash=False )
		return