<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Uygulama Galerisi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
    <style>
        .images {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 100px;
        }
        .images img {
            width: 300px;
        }
        .images .par {
            width: 160px;
            height: 500px;
        }
        .images p {
            height: 100%;
            word-wrap: break-word;
        }
        .img-block {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 50px;
        }
        .navbar {
            background-color: rgb(86, 113, 233);
            opacity: 0.9;
        }
        .navbar-brand img {
            height: 100px;
            max-width: 150px;
        }
        .bg-blue {
            background-color: rgb(86, 113, 233) ; /* Bootstrap birincil mavi tonu */
        }
        .map-responsive {
        overflow: hidden;
        padding-bottom: 56.25%;
        position: relative;
        height: 0;
        }
        .map-responsive iframe {
        left: 0;
        top: 0;
        height: 100%;
        width: 100%;
        position: absolute;
        }


    </style>
    <nav class="navbar navbar-expand-lg navbar-dark shadow-sm sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="/"><img src="images/ParanBurada.svg" /></a>
        </div>
    </nav>

    <section class="contact-us py-5" style="background-color: #f8f9fa;">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="card shadow p-5">
                        <h2 class="text-center mb-4">İletişim Bilgilerim</h2>
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="name" class="form-label">Ad:</label>
                                <input type="text" class="form-control" id="name" value="Taha" >
                            </div>
                            <div class="col-md-6">
                                <label for="surname" class="form-label">Soyad:</label>
                                <input type="text" class="form-control" id="surname" value="Yakıt" >
                            </div>
                        </div>
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="email" class="form-label">E-posta:</label>
                                <input type="email" class="form-control" id="email" value="tahayakit@gmail.com" >
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Telefon:</label>
                                <input type="text" class="form-control" id="phone" value="+90 545 724 4719" >
                            </div>
                        </div>
                        <div class="mt-5">
                            <h4 class="text-center mb-4">Konum</h4>
                            <div class="map-responsive">
                                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d759.4648349900059!2d26.66733630218479!3d40.41196674760228!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14b16f120b9efff3%3A0x8d17e25075bca52b!2sCamiikebir%2C%20Gazi%20Hasan%20Pa%C5%9Fa%20Cd.%20No%3A25%2C%2017500%20Gelibolu%2F%C3%87anakkale!5e0!3m2!1str!2str!4v1736205448712!5m2!1str!2str" width="400" height="300" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                                    width="100%"
                                    height="400"
                                    style="border:0;"
                                    allowfullscreen=""
                                    loading="lazy">
                                </iframe>
                            </div>
                        </div>
                        <div class="text-center mt-5">
                            <a href="mailto:tahayakit@gmail.com" class="btn btn-primary">Mail Gönder</a>
                            <a href="tel:+905457244719" class="btn btn-secondary">Ara</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>




    <footer class="text-center py-4 bg-blue text-white mt-5">
        <p>&copy; 2025 ParanBurada A.Ş. Tüm hakları saklıdır.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
