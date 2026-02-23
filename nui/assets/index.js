/* 
try {
    const date = new Date();

    config.sites.forEach(site => {
        importPage(site);
    });

    function importPage(infos) {
        const pages = document.getElementById('pages');

        const divPage = document.createElement('div');
        divPage.classList.add('page');
        divPage.setAttribute('v-if', `currentPage == "${infos.href}"`);
        divPage.setAttribute('id', infos.href);

        const content = document.createElement('div');
        content.classList.add('content');

        if ('url' in infos) {
            const iframe = document.createElement('iframe');
            iframe.src = infos.url;
            iframe.classList.add('opencad');
            content.appendChild(iframe);
        } else if (infos.href === 'calculatorapp') {
            // Votre code de calculatrice ici
            // ... (code existant)
        } else if (infos.href === 'noteapp') {
            // Code pour l'application de notes
            const noteContent = document.createElement('div');
            noteContent.innerHTML = `
                <h1>Prise de Notes</h1>
                <textarea id="note-textarea" rows="10" cols="50" placeholder="Écrivez vos notes ici..."></textarea>
                <div class='note-buttons'>
                    <button class="save-note">Sauvegarder</button>
                    <button class="clear-note">Effacer</button>
                </div>
            `;

            // Ajout de styles CSS pour l'application de notes
            const style = document.createElement('style');
            style.innerHTML = `
                #note-textarea {
                    width: 100%;
                    padding: 10px;
                    font-size: 16px;
                    border-radius: 8px;
                    border: 1px solid #ccc;
                    resize: none;
                }
                
                .note-buttons {
                    margin-top: 10px;
                }

                .note-buttons button {
                    margin-right: 10px;
                    padding: 10px 20px;
                    border: none;
                    border-radius: 5px;
                    background-color: #f2a922;
                    color: #fff;
                    cursor: pointer;
                    transition: background-color 0.3s;
                }

                .note-buttons button:hover {
                    background-color: #121619;
                }
            `;

            content.appendChild(noteContent);
            document.head.appendChild(style);

            // Ajout des événements pour les boutons Sauvegarder et Effacer
            noteContent.querySelector('.save-note').addEventListener('click', () => {
                const noteText = noteContent.querySelector('#note-textarea').value;
                localStorage.setItem('note', noteText); // Sauvegarde dans le localStorage
                alert('Note sauvegardée !');
            });

            noteContent.querySelector('.clear-note').addEventListener('click', () => {
                noteContent.querySelector('#note-textarea').value = '';
                localStorage.removeItem('note'); // Efface la note du localStorage
                alert('Note effacée !');
            });

            // Charger la note sauvegardée si elle existe
            const savedNote = localStorage.getItem('note');
            if (savedNote) {
                noteContent.querySelector('#note-textarea').value = savedNote;
            }
        } else if (infos.href === 'meteo') {
            // Votre code météo ici
            // ... (code existant)
        } else {
            const iframe = document.createElement('iframe');
            iframe.src = 'https://xelyos.fr';
            iframe.classList.add('opencad');
            content.appendChild(iframe);
        }

        divPage.appendChild(content);
        pages.appendChild(divPage);
    }

    const app = new Vue({
        el: '#tablet',
        data: {
            opened: false,
            currentPage: 'xelyosapp', // Assurez-vous que c'est un href valide dans config.sites
            Calendar: {
                day: date.toLocaleDateString('fr-FR', { weekday: 'long' }),
                date: date.getDate()
            },
            Applications: config.sites,
            calculatorInput: '',
            calculatorPower: false,
            Weather: {
                icon: 'fa-sun',
                condition: 'Ensoleillé',
                temperature: '22'
            },
        },
        mounted() {
            let initial = document.getElementById(this.currentPage);
            if (initial) {
                initial.style.opacity = 1;
            }
        },
        methods: {
            async post(url, data = {}) {
                const response = await fetch(`https://${GetParentResourceName()}/${url}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                return await response.json();
            },
            setPageOpacity(id, value) {
                let page = document.getElementById(id);
                if (page?.style) {
                    page.style.opacity = value;
                }
            },
            switchPage(page) {
                if (this.currentPage === page) return;

                this.setPageOpacity(this.currentPage, 0);
                this.currentPage = page;

                setTimeout(() => {
                    this.setPageOpacity(page, 1);
                }, 50);
            },
            appendToDisplay(value) {
                if (this.calculatorPower) {
                    this.calculatorInput += value;
                }
            },
            calculate() {
                try {
                    this.calculatorInput = eval(this.calculatorInput).toString();
                } catch (error) {
                    this.calculatorInput = 'Erreur';
                }
            },
            clearEntry() {
                this.calculatorInput = this.calculatorInput.slice(0, -1);
            },
            clearDisplay() {
                this.calculatorInput = '';
            },
            togglePower() {
                this.calculatorPower = !this.calculatorPower;
                this.calculatorInput = this.calculatorPower ? '0' : ''; // Affiche '0' si la calculatrice est allumée, sinon vide
            },
            openNotes() {
                this.switchPage('noteapp');
            }
        }
    });

    let getjob = null;

    window.addEventListener('message', async ({ data }) => {
        switch (data.action) {
            case 'open':
                app.opened = true;
                app.Weather.condition = data.weather;
                app.Weather.icon = data.icon;
                app.Weather.temp = data.temp;
                break;
            case 'close':
                app.opened = false;
                break;
        }
    });

    window.addEventListener('keydown', async ({ key }) => {
        let which = key.toLowerCase();

        if (which === 'escape') {
            getjob = null;
            console.log(getjob);
            return await app.post('close');
        }
    });
} catch (error) {
    console.error("Erreur dans le script principal :", error);
}
 */


try {
    const date = new Date();

    config.sites.forEach(site => {
        importPage(site);
    });

    function importPage(infos) {
        const pages = document.getElementById('pages');

        const divPage = document.createElement('div');
        divPage.classList.add('page');
        divPage.setAttribute('v-if', `currentPage == "${infos.href}"`);
        divPage.setAttribute('id', infos.href);

        const content = document.createElement('div');
        content.classList.add('content');

        if ('url' in infos) {
            const iframe = document.createElement('iframe');
            iframe.src = infos.url;
            iframe.classList.add('opencad');
            content.appendChild(iframe);
        } else if (infos.href === 'calculatorapp') {
            // Votre code de calculatrice ici
            const calculatorContent = document.createElement('div');
            calculatorContent.innerHTML = `
                <h1>Calculatrice</h1>
                <div class='calculator'>
                    <input type='text' id='display' v-model="calculatorInput" disabled>
                    <div class='buttons'>
                        <button class="function" @click='clearDisplay()'>C</button>
                        <button class="function" @click='clearEntry()'>CE</button>
                        <button class="function on-off" @click='togglePower()'>ON/OFF</button>
                        <button class="operator" @click='appendToDisplay("/")'>÷</button>
                        <button @click='appendToDisplay("7")'>7</button>
                        <button @click='appendToDisplay("8")'>8</button>
                        <button @click='appendToDisplay("9")'>9</button>
                        <button class="operator" @click='appendToDisplay("*")'>×</button>
                        <button @click='appendToDisplay("4")'>4</button>
                        <button @click='appendToDisplay("5")'>5</button>
                        <button @click='appendToDisplay("6")'>6</button>
                        <button class="operator" @click='appendToDisplay("-")'>-</button>
                        <button @click='appendToDisplay("1")'>1</button>
                        <button @click='appendToDisplay("2")'>2</button>
                        <button @click='appendToDisplay("3")'>3</button>
                        <button class="operator" @click='appendToDisplay("+")'>+</button>
                        <button class="zero" @click='appendToDisplay("0")'>0</button>
                        <button class="equals" @click='calculate()'>=</button>
                        <button @click='appendToDisplay(".")'>.</button>
                    </div>
                </div>
            `;

            // Ajout de styles CSS
            const style = document.createElement('style');
            style.innerHTML = `
                .calculator {
                    background-color: #333;
                    border: 2px solid #444;
                    border-radius: 10px;
                    overflow: hidden;
                    width: 320px;
                    margin: 0 auto;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
                }
        
                #display {
                    width: 100%;
                    margin-bottom: 10px;
                    padding: 10px;
                    font-size: 24px;
                    background-color: #444;
                    border: none;
                    color: #fff;
                    border-radius: 8px;
                    text-align: right;
                    outline: none;
                }
        
                .buttons {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 10px;
                    padding: 10px;
                }
        
                .buttons button {
                    width: 100%;
                    height: 60px;
                    font-size: 18px;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: background-color 0.3s ease;
                    outline: none;
                    color: #fff;
                    background-color: #e74c3c;
                }
        
                .buttons button:hover {
                    filter: brightness(1.2);
                }
        
                .buttons button:active {
                    filter: brightness(0.8);
                }
        
                .function, .zero {
                    background-color: #e74c3c;
                }
        
                .function.on-off {
                    background-color: #e74c3c;
                }
        
                .operator, .equals, .sqrt {
                    background-color: #e74c3c;
                }
        
                .zero {
                    grid-column: span 2;
                }
            `;

            // Ajout des éléments au DOM
            content.appendChild(calculatorContent);
            document.head.appendChild(style);
        } else if (infos.href === 'noteapp') {
            // Code pour l'application de notes
            const noteContent = document.createElement('div');
            noteContent.innerHTML = `
                <h1>Prise de Notes</h1>
                <textarea id="note-textarea" rows="10" cols="50" placeholder="Écrivez vos notes ici..."></textarea>
                <div class='note-buttons'>
                    <button class="save-note">Sauvegarder</button>
                    <button class="clear-note">Effacer</button>
                </div>
            `;

            // Ajout de styles CSS pour l'application de notes
            const style = document.createElement('style');
            style.innerHTML = `
                #note-textarea {
                    width: 100%;
                    padding: 10px;
                    font-size: 16px;
                    border-radius: 8px;
                    border: 1px solid #ccc;
                    resize: none;
                }
                
                .note-buttons {
                    margin-top: 10px;
                }

                .note-buttons button {
                    margin-right: 10px;
                    padding: 10px 20px;
                    border: none;
                    border-radius: 5px;
                    background-color: #f2a922;
                    color: #fff;
                    cursor: pointer;
                    transition: background-color 0.3s;
                }

                .note-buttons button:hover {
                    background-color: #121619;
                }
            `;

            content.appendChild(noteContent);
            document.head.appendChild(style);

            // Ajout des événements pour les boutons Sauvegarder et Effacer
            noteContent.querySelector('.save-note').addEventListener('click', () => {
                const noteText = noteContent.querySelector('#note-textarea').value;
                localStorage.setItem('note', noteText); // Sauvegarde dans le localStorage
                alert('Note sauvegardée !');
            });

            noteContent.querySelector('.clear-note').addEventListener('click', () => {
                noteContent.querySelector('#note-textarea').value = '';
                localStorage.removeItem('note'); // Efface la note du localStorage
                alert('Note effacée !');
            });

            // Charger la note sauvegardée si elle existe
            const savedNote = localStorage.getItem('note');
            if (savedNote) {
                noteContent.querySelector('#note-textarea').value = savedNote;
            }
        } else if (infos.href === 'meteo') {
            // Votre code météo ici
            // ... (code existant)
        } else {
            const iframe = document.createElement('iframe');
            iframe.src = 'https://xelyos.fr';
            iframe.classList.add('opencad');
            content.appendChild(iframe);
        }

        divPage.appendChild(content);
        pages.appendChild(divPage);
    }

    const app = new Vue({
        el: '#tablet',
        data: {
            opened: false,
            currentPage: 'main', // Assurez-vous que c'est un href valide dans config.sites
            Calendar: {
                day: date.toLocaleDateString('fr-FR', { weekday: 'long' }),
                date: date.getDate()
            },
            Applications: config.sites,
            calculatorInput: '',
            calculatorPower: false,
            Weather: {
                icon: 'fa-sun',
                condition: 'Ensoleillé',
                temperature: '22'
            },
        },
        mounted() {
            /* if (!this.currentPage) return; */
            let initial = document.getElementById(this.currentPage);
            if (initial) {
                initial.style.opacity = 1;
            }
        },
        methods: {
            async post(url, data = {}) {
                const response = await fetch(`https://${GetParentResourceName()}/${url}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                return await response.json();
            },
            setPageOpacity(id, value) {
                let page = document.getElementById(id);
                if (page?.style) {
                    page.style.opacity = value;
                }
            },
            switchPage(page) {
                if (this.currentPage === page) return;

                this.setPageOpacity(this.currentPage, 0);
                this.currentPage = page;

                setTimeout(() => {
                    this.setPageOpacity(page, 1);
                }, 50);
            },
            appendToDisplay(value) {
                if (this.calculatorPower) {
                    this.calculatorInput += value;
                }
            },
            calculate() {
                try {
                    this.calculatorInput = eval(this.calculatorInput).toString();
                } catch (error) {
                    this.calculatorInput = 'Erreur';
                }
            },
            clearEntry() {
                this.calculatorInput = this.calculatorInput.slice(0, -1);
            },
            clearDisplay() {
                this.calculatorInput = '';
            },
            togglePower() {
                this.calculatorPower = !this.calculatorPower;
                this.calculatorInput = this.calculatorPower ? '0' : ''; // Affiche '0' si la calculatrice est allumée, sinon vide
            },
            openNotes() {
                this.switchPage('noteapp');
            }
        }
    });

    let getjob = null;

    window.addEventListener('message', async ({ data }) => {
        switch (data.action) {
            case 'open':
                app.opened = true;
                app.Weather.condition = data.weather;
                app.Weather.icon = data.icon;
                app.Weather.temp = data.temp;
                break;
            case 'close':
                app.opened = false;
                break;
        }
    });

    window.addEventListener('keydown', async ({ key }) => {
        let which = key.toLowerCase();

        if (which === 'escape') {
            getjob = null;
            return await app.post('close');
        }
    });
} catch (error) {
    //console.error("Erreur dans le script principal :", error);
}