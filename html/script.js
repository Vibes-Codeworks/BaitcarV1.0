function sendAction(action) {
    fetch(`https://${GetParentResourceName()}/baitcarAction`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ action })
    });
}

window.addEventListener('message', (event) => {
    if (event.data.type === 'showMenu'){
        document.getElementById('menu').style.display = 'block';
    } else if (event.data.type === 'hideMenu') {
        document.getElementById('menu').style.display = 'none';
    }
});