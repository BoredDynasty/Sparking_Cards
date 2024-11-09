// HTML Styling (kinda)

var body = document.body;

// Headers
var welcomeHeader = document.getElementById("cards_welcome");
var welcomeP = document.getElementById("cards_p");
welcomeHeader.textContent = "Sparking Cards!";
welcomeP.textContent = "Sparking Cards is almost here!";
welcomeHeader.appendChild(body)

// Buttons
var githubLink = document.getElementById("github_link");
githubLink.textContent = "Source Code";
githubLink.classList.add("link_style_1");
githubLink.href = "https://github.com/BoredDynasty/Sparking_Cards";

// Images
var cardsImgHead = document.getElementById("cards_img_head");
cardsImgHead.src = "https://github.com/BoredDynasty/Sparking_Cards/blob/main/Files/Images/Sparking%20Cards%20Transparent%20$20BG.png?raw=true";
cardsImgHead.classList.add("img_style_1");
cardsImgHead.style.position = "absolute";
cardsImgHead.style.top = "0";
cardsImgHead.style.left = "0";
