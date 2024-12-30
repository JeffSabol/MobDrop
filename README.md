# Spells 4 The Ducks

Play on itch.io! https://b0rked.itch.io/spells-4-the-ducks

![image](https://github.com/user-attachments/assets/0cff3742-f279-4381-9099-905a0ce458f7)
![image](https://github.com/user-attachments/assets/c8521e99-94b2-438e-ab3f-651ef6b10137)



**Controls:**
- Q = Select spell menu
- W, A, D = Jump,  walk left, walk right
- Left Mouse Button = Fire spell

**Description:**
Play as a magical duck with friends online using the correct spell to defeat four different enemies!
Multiplayer using a dedicated server with ENet! Just hit the JOIN button to connect with others. All the port forwarding is done already on the dedicated server.

**Why no web export?**
Web browsers do not support ENet, the multiplayer networking protocol **Spells 4 The Birds** is using. ENet allows us to handle real-time multiplayer with low-latency communication using UDP (a fast and efficient networking protocol). Unfortunately, web browsers rely on WebSockets, which use TCP instead of UDP. This can introduce more lag and doesn't offer the same performance as ENet.

While it's possible to create a special server just for WebSocket support, this would require significantly different architecture, and for now, we’re focused on making the best experience possible on native platforms like Windows, MacOS, Linux, and Android.
