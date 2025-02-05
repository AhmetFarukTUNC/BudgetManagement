<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParanBurada</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        nav {
            background-color: rgb(86, 113, 233);
            opacity: 0.9;
        }
        .hero-section {
            background: url('images/pexels-vinnie-de-carvalho-133983131-10215999.jpg') center center/cover;
            color: white;
            height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .btn-custom {
            background-color: rgb(86, 113, 233);
            color: #000;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .btn-custom:hover {
            color: black;
            background-color: white;
        }
        .footer-link {
            color: white;
            text-decoration: none;
        }
        .footer-link:hover {
            text-decoration: underline;
        }
        .social-icons a {
            color: black;
            margin: 0 15px;
            font-size: 1.5rem;
            transition: transform 0.3s ease;
        }
        .social-icons a:hover {
            transform: scale(1.2);
            color: black;
        }
        .why-us {
            padding: 100px 0;
        }
        .why-us h2 {
            margin-bottom: 30px;
        }
        .bg-blue {
            background-color: rgb(86, 113, 233) ; /* Bootstrap birincil mavi tonu */
        }
        .nav-link {
            color: black;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark  shadow-sm sticky-top">
        <div class="container-fluid d-flex align-items-center">
            <a class="navbar-brand d-flex align-items-center" href="/">
                <img src="{{ asset('images/ParanBurada.svg') }}" alt="logo" class="img-fluid me-2" style="height: 100px; max-width: 150px;">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Ana Sayfa</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/gallery">Galeri</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/contact">İletişim</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="hero-section">
        <div>
            <h1 class="display-3 text-black">Bütçenizi Kontrol Altında Tutun</h1>
            <p class="lead text-black">ParanBurada ile finansal özgürlüğe bir adım daha yakınsınız.</p>
            <a href="/gallery" class="btn btn-custom btn-lg mt-4">Galeriye Göz Atın</a>
            <a href="/images/app-release.apk" class="btn btn-custom btn-lg mt-4" download>Uygulamayı İndir</a>
        </div>
    </div>



    <section class="why-us" style="background-image: url('{{ asset('/images/') }}'); background-size: cover; background-position: center; background-repeat: no-repeat; padding: 50px 0;">>
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2>Neden Biz?</h2>
                    <p>ParanBurada, finansal yönetimi kolaylaştıran yenilikçi çözümler sunar. Kullanıcı dostu arayüzü, güvenlik önlemleri ve verimliliği artıran özellikleriyle ParanBurada, bütçenizi en iyi şekilde yönetmenize yardımcı olur.
                    ParanBurada ile mali hedeflerinize ulaşmanız artık çok daha kolay ve güvenli.</p>
                    <a href="/about" class="btn btn-custom mt-4">Daha Fazla Bilgi</a>
                </div>
                <div class="col-md-6 text-center">
                    <img src="{{ asset('/images/pexels-bayfilm9-15377956.jpg') }}" alt="Neden Biz?" class="img-fluid rounded shadow">
                </div>
            </div>
        </div>
    </section>

    <footer class="text-center py-4 bg-blue text-white mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>Hakkımızda</h5>
                    <a href="/privacy" class="footer-link">Gizlilik Politikası</a><br>
                    <a href="/contact" class="footer-link">İletişim</a>
                </div>
                <div class="col-md-4 social-icons">
                    <h5>Bizi Takip Edin</h5>
                    <a href="https://www.facebook.com/tahayakit" target="_blank"><i class="fab fa-facebook"></i></a>
                    <a href="https://www.instagram.com/taha.ykt" target="_blank"><i class="fab fa-instagram"></i></a>
                    <a href="https://x.com/tahayakit" target="_blank"><i class="fab fa-twitter"></i></a>
                    <a href="https://www.linkedin.com/in/taha-yakıt-65820823b" target="_blank"><i class="fab fa-linkedin"></i></a>
                </div>
                <div class="col-md-4">
                    <p>&copy; 2025 <a href="/" class="footer-link">ParanBurada A.Ş.</a> Tüm hakları saklıdır.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
