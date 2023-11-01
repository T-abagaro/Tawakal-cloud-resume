const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch("https://rn4bkxtfw5urouhnb5lyj2niim0ssqlq.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = ` views: ${data}`;
}

updateCounter();