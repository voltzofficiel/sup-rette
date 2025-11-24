const app = document.getElementById('app');
const backdrop = document.getElementById('backdrop');
const categoriesRoot = document.getElementById('categories');
const productsRoot = document.getElementById('products');
const closeBtn = document.getElementById('close');
const shopIdLabel = document.getElementById('shop-id');

let categories = [];
let activeCategory = null;
let currentShop = 1;

const sounds = {
    click: new Audio('https://cdn.freesound.org/previews/341/341695_616649-lq.mp3'),
    add: new Audio('https://cdn.freesound.org/previews/256/256113_3263906-lq.mp3')
};

function play(sound) {
    const audio = sounds[sound];
    if (!audio) return;
    audio.currentTime = 0;
    audio.volume = 0.2;
    audio.play();
}

function renderCategories() {
    categoriesRoot.innerHTML = '';
    const tpl = document.getElementById('category-template');

    categories.forEach((cat, index) => {
        const node = tpl.content.cloneNode(true);
        const button = node.querySelector('.category');
        button.dataset.name = cat.name;
        button.style.borderColor = cat.color;
        button.querySelector('.icon').textContent = cat.icon || '•';
        button.querySelector('.label').textContent = cat.label;
        if (!activeCategory && index === 0) activeCategory = cat.name;
        if (activeCategory === cat.name) button.classList.add('active');

        button.addEventListener('click', () => {
            activeCategory = cat.name;
            renderCategories();
            renderProducts();
            play('click');
        });

        categoriesRoot.appendChild(node);
    });
}

function renderProducts() {
    productsRoot.innerHTML = '';
    const tpl = document.getElementById('product-template');

    const category = categories.find((c) => c.name === activeCategory) || categories[0];
    if (!category) return;

    category.items.forEach((item) => {
        const node = tpl.content.cloneNode(true);
        const card = node.querySelector('.card');
        const img = node.querySelector('img');
        const price = node.querySelector('.price');
        const title = node.querySelector('.title');
        const badge = node.querySelector('.badge');
        const input = node.querySelector('input');
        const addBtn = node.querySelector('button');

        img.src = item.image || 'assets/placeholder.svg';
        img.alt = item.label;
        img.onerror = () => {
            img.onerror = null;
            img.src = 'assets/placeholder.svg';
        };
        price.textContent = `$${item.price}`;
        title.textContent = item.label;
        badge.textContent = category.label;

        addBtn.addEventListener('click', () => {
            const qty = Math.max(1, parseInt(input.value, 10) || 1);
            fetch(`https://${GetParentResourceName()}/purchase`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify({ name: item.name, quantity: qty })
            });
            play('add');
        });

        productsRoot.appendChild(node);
    });
}

closeBtn.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
    play('click');
});

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'open') {
        categories = data.categories || [];
        activeCategory = categories[0]?.name || null;
        currentShop = data.shop || 1;

        shopIdLabel.textContent = String(currentShop).padStart(2, '0');
        app.classList.remove('hidden');
        backdrop.classList.add('show');
        renderCategories();
        renderProducts();
    }

    if (data.action === 'close') {
        app.classList.add('hidden');
        backdrop.classList.remove('show');
    }
});

document.addEventListener('keyup', (e) => {
    if (e.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
    }
});
