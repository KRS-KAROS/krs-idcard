$(document).ready(function () {
  window.addEventListener('message', function (event) {
    if (event.data.action == 'open') {
      var type = event.data.type;
      var userData = event.data;
      $('#name').css('color', '#ffffff');
      $('#name').text(`${userData.f} ${userData.l}`);
      $('#dob').text(userData.dob);
      $('#signature').text(`${userData.f} ${userData.l}`);
      if (type != 'portoarmi') {
        if (typeof userData === 'object' && userData.s && userData.s.toLowerCase() == 'm') {
          $('#sex').text('M');
        } else {
          $('#sex').text('F');
        }
        $('#height').text(userData.h);
      }
      $('#mydiv').css('background-image', `url(${userData.foto})`);
      switch (type) {
        case 'patentea':
          $('#licenses').append('<p> moto </p>');
          $('#id-card').css('background', 'url(assets/images/patente.png)');
          break;
        case 'patenteb':
          $('#licenses').append('<p> auto </p>');
          $('#id-card').css('background', 'url(assets/images/patente.png)');
          break;
        case 'patentec':
          $('#licenses').append('<p> camion </p>');
          $('#id-card').css('background', 'url(assets/images/patente.png)');
          break;
        case 'portoarmi':
          $('#licenses').append('<p>porto d\'armi</p>');
          $('#id-card').css('background', 'url(assets/images/portoarmi.png)');
          break;
        default:
          $('#id-card').css('background', 'url(assets/images/documento.png)');
          break;
      }
      $('#id-card').show();
    } else if (event.data.action == 'customfoto') {
      $('#customfoto').css('background-image', "url('" + event.data.link + "')");
      $('#customfoto').css('display', 'block');
    } else if (event.data.action == 'close') {
      $('#name').text('');
      $('#dob').text('');
      $('#height').text('');
      $('#signature').text('');
      $('#sex').text('');
      $('#id-card').hide();
      $('#licenses').html('');
      $('#customfoto').css('display', 'none');
    }
  });
});
