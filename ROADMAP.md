# Roadmap

## MVP
- [x] Login
- [x] Register
- [x] Supabase
- [x] Login amb nickname
- [x] Biblioteca d'usuari
- [x] Cerca IGDB
- [x] Afegir joc
- [x] Reviews
- [x] Perfil

## v1.0 Official release
- [x] Estadístiques
- [x] Amics
- [x] Resum de reviews
- [x] Sistema d'amics
- [x] Model SocialPost 
- [x] Generació automàtica de posts 
- [x] Feed d'amics + amics d'amics 
- [x] Cards/popups de posts 
- [x] Descobrir nous jugadors
- [ ] Esborrar compte
- [ ] Recuperació/canvi password
- [ ] Política de privacitat/cookies
- [ ] About

## v1.1 Social Update
- [ ] Compartir perfil
- [ ] Sistema de likes
- [ ] Notificacions
- [ ] Themes
- [ ] Recomanació de jocs/llistes/jugadors


## To do before full release
🔐 Recuperar contrasenya — preparar la pantalla i el flux, sense necessitat d'enviar ara cap email.
🔑 Canviar contrasenya des d'Editar perfil — UI + updateUser.
🗑️ Eliminar compte — ja tens l'Edge Function funcionant; podem polir confirmació, loading i logout.
🛡️ Revisar RLS — molt important abans de publicar, especialment perquè ara tens:
user_games visibles per qualsevol usuari autenticat.
profiles públics.
friendships.
activities.
🌐 Preparar l'aplicació web per producció — variables/configuració, URL de producció, Supabase Auth redirects, etc.
📱 Responsive — revisar que GameShelf es vegi bé en mòbil, tablet i escriptori.
⚠️ Gestió d'errors — substituir errors tècnics de Supabase per missatges comprensibles.
👤 Perfil — acabar de polir edició, avatar, email, contrasenya i eliminació.
🎮 Activitats — deixar els likes/notificacions per més endavant, com havíem dit.
🚀 Deploy final — Netlify/Vercel/etc. + domini si vols.
