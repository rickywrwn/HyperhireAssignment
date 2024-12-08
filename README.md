<h1>Hyperhire Assignment</h1>
Project Overview
<br>
I made this project using UIKit programatically with Clean Architecture approach using: 
<ul>
  <li>MVVM as design pattern</li>
  <li>Coordinator for handling navigations</li>
  <li>Depedency Injection Container and DI Factory</li>
  <li>Repository</li>
  <li>Use Case</li>
  <li>Seperating each Service (e.g. Network Service & Cache Service)</li>
</ul>

The reason i use Clean Architecture approach is to promote loose coupling and separation of concern. 
<br>
It also make future unit test easier by creating seperate mock file.

For playlist persistent i use FileManager cache, Kingfisher for loading network image, and FloatingPanel to create floating view.

<h1>Preview</h1>

<video src="https://github.com/user-attachments/assets/3f0235d2-ffa5-4029-a15e-932dd8963c9b" width="300" />

