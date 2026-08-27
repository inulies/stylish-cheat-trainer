# Stylish Cheat Trainer

Um trainer open-source e modular para Devil May Cry 5, construído **100% em Lua** utilizando a API do REFramework. 

O Trainer nasceu como uma alternativa leve e acessível a outros trainers compilados (como o SSSiyan). Focado em scripts puros, ele elimina a necessidade de injetar DLLs customizadas para cada alteração, permitindo que a comunidade modifique, estude e expanda os cheats diretamente pelo código-fonte de forma escalável.

O Trainer é 100% compatível no Linux, sem crashs detectados, e sem injeção de DLL
Sistema testado: CachyOS com kernel LTS

---

## ⚙️ Funcionalidades Atuais

O painel do trainer pode ser acessado diretamente pelo menu de scripts do REFramework e inclui:

*   **Mods Globais:**
    *   **No Damage:** Mantém os personagens ivulneráveis a dano e reações de hit. Agarrões e empurrões ainda terão efeito, mas não será computado dano.
    *   **Devil Trigger Regeneration:** Recuperação constante da barra de DT. A barra regenera mesmo durante transoformações, tendo uma taxa de regen infinita.
*   **Mods Específicos (Nero):**
    *   **Infinite Exceed:** Mantém os 3 estoques e o nível de Exceed da Red Queen no máximo. Não gasta quando ataca.
    *   **Infinite Color Up Shot:** Mantém os tiros "Colorir" da Blue Rose sempre carregadas. O tambor permanece cheio e não diminui no uso
    *   **Instant Charge Shot:** Ao atirar o tiro será como se tivesse com Charge Shot Nv 3.
*   **Mods Específicos (V):**
    *   **Não implementado** - Atualmente sem funcionalidades especificas do personagem. 
*   **Mods Específicos (Dante):**
    *   **Infinite SDT:** Mantém o SDT no máximo constantemente, impedindo que desça. Para destransformar do Sin Devil Trigger, é necessário desabilitar o mod e esperar a barra cair.
    *   **Balrog Never Extinguish:** Ao atirar o tiro será como se tivesse com Charge Shot Nv 3.
*   **Mods Específicos (Vergil):**
    *   **Infinite SDT:** Mantém o SDT no máximo constantemente, impedindo que desça. Não gasta ao usar habilidades máximas de arma
    *   **Concentration never decrease:** Estabelece um valor inicial de concentração, impede que desça por qualquer motivo.

---

## 🛠️ Instalação

1.  Certifique-se de ter o **[REFramework](https://github.com/praydog/REFramework)** instalado no seu Devil May Cry 5.
3.  Extraia o arquivo e coloque-o no diretório raiz do seu jogo.
4.  A estrutura final deve ficar assim:
    ```text
    /Devil May Cry 5
      /reframework
        /data
        /autorun
          /helpers
          StylishCheatTrainer.lua
    ```
5.  Abra o jogo, aperte `Insert` para abrir o menu do REFramework e procure por **Stylish Cheat Trainer** na aba *Script Generated UI*.

---
