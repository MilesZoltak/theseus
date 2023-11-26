# Theseus

This is a repository housing the contents of my final project I did jointly for **CS 231A: Computer Vision, From 3D Reconstruction to Recognition** and **CS 238: Decision Making Under Uncertainty**.  For my project, I created a Flask App that ran inference on an absolute monocular depth estimation model.  The purpose was to serve as an endpoint a phone could use to sightlessly navigate a room using just its own camera.  The endpoint communicated back the estimated distance to objects in front of the camera so that the person holding the phone could navigate around a room with obstacles.  While using the phone, the user would be blindfolded and be constantly fed information through a continuous loop of photos sent to the endpoint and data read back using a text to speech system for the user.

The majority of this repo is the Flutter app, endpoint.ipynb is the file that was run in Google Colab that served as the endpoint.

Read my final paper [here](https://drive.google.com/file/d/1wBqELybVVLQDbDPOWhpk3obSzCBFAXMp/view?usp=drive_link).
