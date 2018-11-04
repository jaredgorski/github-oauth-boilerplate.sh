# github-oauth-boilerplate.sh
Boilerplate OAuth flow for **shell** scripts integrating with the Github v3 API


![](/.media/gh_oauth_bp-demo.gif)


# The Basics

It is surprisingly easy to add OAuth to your Github-integrated application. Hopefully this boilerplate, though basic, is enough to get you started!

## 10 Easy Steps:
1) Clone this repository to your computer
2) Navigate to the resulting directory
3) Open ./auth.sh in vim - `vim ./auth.sh`
4) Replace "XXXX..." with your OAuth application's [CLIENT_ID and CLIENT_SECRET](https://developer.github.com/v3/guides/basics-of-authentication/#registering-your-app) on *lines 15 and 16*
5) Exit vim and execute `source ./auth.sh`
6) Execute `login` to initiate basic Github OAuth flow *(NOTE: a .session.sh file is temporarily created)*
7) Execute `logout` to logout of Github OAuth *(NOTE: your Github token is stored in .token.sh)*
8) Review code and comments on auth.sh and read [Github's v3 API documentation](https://developer.github.com/v3/)
9) Extend code if needed and use in your application
10) Participate: leave a comment, open issues, send improvements, and give a star if you like what you see :blush:

---

### A note on 2-Factor Authentication:
This boilerplate does not yet support 2-Factor Authentication, but this is in the works. See the following link if you would like to extend the code yourself, and feel free to send a pull-request if you do!

Implementing 2-Factor Authentication: https://developer.github.com/v3/auth/#working-with-two-factor-authentication
