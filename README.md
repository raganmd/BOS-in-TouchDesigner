# BOS-in-TouchDesigner

**Matthew Ragan** |[ matthewragan.com ](http://matthewragan.com) 

I can't say enough good things about [The Book of Shaders](https://thebookofshaders.com/) by  [Patricio Gonzalez Vivo](http://patriciogonzalezvivo.com/) & [Jen Lowe](http://jenlowe.net/). If you're looking to get a handle on how to write shaders, or find some inspiration this is an incredible resource.  

For TouchDesigner programmers who are accustomed to the nodal environment of TD, working with straight code might feel a bit daunting - and making the transition from Patrico's incredible resource to Touch might feel hard - it certainly was for me at first. This repo is really about helping folks make that jump. 

Here you'll find the incredible examples made by Patricio and Jen ported to the TouchDesigner environment. There are some differences here, and I'll do my best to help provide some clarity about where those come from. 

This particular set of examples is made in [TouchDesigner 099](https://www.derivative.ca/099/Downloads/). In the UI you'll find a list of examples below the rendered shader in the left pane, on the right you'll find the shader code and the contents of an info DAT. You can live edit the contents of the shader code, you just have to click off of the pane for the code to be updated under the hood. If you hit the escape key you can dig into the network to see how everything is organized.

Each ported shader exists as a stand alone file - making it easy to drop the pixel shader into another network. When possible I've tried to precisely preserve the shader from the original, though there are some cases where small alterations have been made. In the case of touch specific uniforms I've tried to make sure there are notes for the programmer to see what's happening. 

![Touch Screen Shot](https://raw.githubusercontent.com/raganmd/BOS-in-TouchDesigner/master/repo-assets/BOS-screen-shot.PNG)
