// HTML Styling (kinda)

var body = document.body;

// Defining Variables
var linkBG = "#1446ff";
var linkBGHover = "#5c7af1";
var backgroundColor = "#111216";
var textColor = "white";
var borderColor = "#2c2e34";

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
githubLink.style.backgroundColor = linkBG;

// Images
var cardsImgHead = document.getElementById("cards_img_head");
cardsImgHead.src = "https://github.com/BoredDynasty/Sparking_Cards/blob/web/Files/Images/SparkingCardsTransparerentBG.png?raw=true";
cardsImgHead.classList.add("img_style_1");
cardsImgHead.style.position = "absolute";
cardsImgHead.style.top = "0";
cardsImgHead.style.left = "0";
cardsImgHead.style.backgroundColor = "transparent";