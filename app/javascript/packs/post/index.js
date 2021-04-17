

const SetModal = (modal, span, btn)=>{
  for(let i = 0; i < btn.length; i++) {
    	btn[i].addEventListener('click', (e)=>{
        modal[i].style.display = "block";

    	});
      span[i].addEventListener('click',(e)=>{
        modal[i].style.display = 'none';

      });
      window.addEventListener('click',(e)=>{
        if(e.target == modal[i]) {
          modal[i].style.display = 'none';
        }
      });
  }
}

let comment_btns = document.getElementsByClassName('post-footer__comment-btn');
let modal_comment = document.getElementsByClassName('modal-comment');
let span_comment = document.getElementsByClassName('modal-comment__close');
SetModal(modal_comment, span_comment, comment_btns);



let watched_btns = document.getElementsByClassName('left-container__watched-btn');
let modal_register = document.getElementsByClassName('modal-register');
let span_register = document.getElementsByClassName('modal-register__close');
SetModal(modal_register, span_register, watched_btns);



let profile_btns = document.getElementsByClassName('modal-edit-profile__btn');
let modal_profile = document.getElementsByClassName('modal-edit-profile');
let span_profile = document.getElementsByClassName('modal-edit-profile__close');
SetModal(modal_profile, span_profile, profile_btns);
