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
    </style>
    <nav class="navbar navbar-expand-lg navbar-dark shadow-sm sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="/"><img src="images/ParanBurada.svg" /></a>
        </div>
    </nav>

    <section class="container mt-5 text-center">
        <h1>Uygulama Galerisi</h1> <br> <br>
        <section class="home">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1>Ana Sayfa</h1> <br>
                        <p>Bu mobil uygulama ekranı, kişisel bütçe yönetimi ve gelir-gider takibini kolaylaştıran bir sistemin ana sayfasını göstermektedir.
                            Kullanıcı dostu arayüzüyle, toplam bakiye, gelir ve gider bilgileri net bir şekilde sunulmaktadır.
                            Üst bölümde kullanıcının adı ve selamlaması yer alırken, altında toplam bakiye büyük bir fontla belirtilmiştir.
                            Toplam gelir ve giderler farklı renklerde kutucuklarla vurgulanarak finansal durumun hızlı bir şekilde anlaşılması sağlanmıştır.
                            Gelir - gider listesi, harcamaların ve kazançların detaylarıyla birlikte tarih ve saat bazında sıralanmıştır.
                            Ekranın alt kısmında ise ana sayfa, ekleme, detaylar, hesaplar ve bildirim gibi sekmeler yer alarak kolay navigasyon imkanı sunulmaktadır. </p>
                    </div>
                    <div class="col-md-6 text-center">
                        <img src="{{ asset('images/home.png') }}" alt="Ana Sayfa" class="img-fluid rounded shadow">
                    </div>
                </div>
            </div>
        </section>

        <section class="menu">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1>Yan Menü</h1> <br>
                        <p>Bu mobil uygulama ekranı, bir bütçe yönetim sisteminin yan menüsünü göstermektedir.
                           Kullanıcı profili, ad ve fotoğraf ile menünün üst kısmında yer almakta, böylece kişiselleştirilmiş bir deneyim sunulmaktadır.
                           Menünün alt kısmında ise bildirimler, hesaplar, detaylar, ekleme, ana sayfa ve kategori ekleme gibi çeşitli seçenekler bulunmaktadır.
                           Bu menü, kullanıcının uygulama içinde hızlıca gezinmesini ve ihtiyaç duyduğu işlemleri kolaylıkla gerçekleştirmesini sağlar.
                           Basit ve sade tasarımıyla, kullanıcı dostu bir arayüz sunarak finansal verilerin yönetimini pratik hale getirmektedir. </p>
                    </div>
                    <div class="col-md-6 text-center">
                        <img src="{{ asset('images/solyan.png') }}" alt="Menu" class="img-fluid rounded shadow">
                    </div>
                </div>
            </div>
        </section>


        <section class="butcekalem">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1>Bütçe Kalemi Ekleme Ekranı</h1> <br>
                        <p>Bu mobil uygulama ekranı, kullanıcıların bütçe kalemi eklemelerine olanak tanıyan "Bütçe Kalemi Ekleme" sayfasını göstermektedir.
                            Bu sayfada, bir gelir veya gider kalemi eklemek için gerekli alanlar bulunmaktadır.
                            Kullanıcı, "Ad", "Açıklama" ve "Fiyat" alanlarını doldurarak işlemini detaylandırabilir.
                            Ayrıca, tür seçimi ve kalemin gelir mi yoksa gider mi olduğunu belirlemek için iki ayrı açılır menü sunulmaktadır. "Ekle" butonu, verilerin kaydedilmesini sağlar.
                            Sayfanın alt kısmında yer alan navigasyon çubuğu sayesinde ana sayfa, ekleme, detaylar, hesaplar ve bildirimler arasında kolayca geçiş yapılabilir.
                            Bu yapı, kullanıcıların finansal yönetim süreçlerini hızlı ve pratik bir şekilde gerçekleştirmelerine yardımcı olur. </p>
                    </div>
                    <div class="col-md-6 text-center">
                        <img src="{{ asset('images/ekle.png') }}" alt="Menu" class="img-fluid rounded shadow">
                    </div>
                </div>
            </div>
        </section>

        <section class="borc">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1>Borç Detayları Sayfası</h1> <br>
                        <p>Bu mobil uygulama ekranı, kullanıcının borç ve alacak kalemlerini takip edebileceği "Borç Detayları" sayfasını göstermektedir.
                            Her bir işlem, kullanıcı adı, açıklama, işlem tarihi ve saati, kategori bilgisi ve işlem türü (gelir veya gider) ile listelenmiştir.
                            Gelirler yeşil renkte, giderler ise kırmızı renkte işaretlenerek finansal durumun kolayca anlaşılması sağlanmıştır.
                            Bu sayfa, kullanıcının geçmiş işlemlerini detaylı bir şekilde gözlemlemesine ve bütçe yönetimini daha etkin bir şekilde yapmasına yardımcı olur.
                            Alt kısımdaki navigasyon çubuğu, ana sayfa, ekleme, detaylar, hesaplar ve bildirimler arasında hızlı geçiş imkanı sunarak kullanıcı deneyimini artırır. </p>
                    </div>
                    <div class="col-md-6 text-center">
                        <img src="{{ asset('images/borç.png') }}" alt="borc" class="img-fluid rounded shadow">
                    </div>
                </div>
            </div>
        </section>


        <section class="bildirim">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1>Bildirim Sayfası</h1> <br>
                        <p>Bu mobil uygulama ekranı, bütçe yönetim sistemi içinde bildirimler bölümünü göstermektedir.
                           Kullanıcı, gerçekleştirdiği işlemlerle ilgili güncellemeleri bu ekranda takip edebilmektedir.
                           Bildirim listesinde "Bilanço Güncellemesi" ve "Kategori Güncellemesi" gibi farklı işlem türleri tarih bazında sıralanmaktadır.
                           Her bildirimde işlem detayı ve tarihi net bir şekilde belirtilmiş olup, tamamlanan işlemler onay simgesiyle vurgulanmaktadır.
                           Alt kısımda bulunan navigasyon çubuğu, kullanıcıya ana sayfa, ekleme, detaylar, hesaplar ve bildirimler arasında kolay geçiş yapma imkanı sunar. </p>
                    </div>
                    <div class="col-md-6 text-center">
                        <img src="{{ asset('images/bildirim.png') }}" alt="bildirim" class="img-fluid rounded shadow">
                    </div>
                </div>
            </div>
        </section>


        <section class="hesap">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1>Kullanıcı Hesabı Sayfası</h1> <br>
                        <p>Bu mobil uygulama ekranı, kullanıcının hesap yönetimi için tasarlanmış "Hesaplar" sayfasını göstermektedir.
                           Ekranda, kullanıcı adı "hakan" olarak belirtilmiş ve profil simgesiyle birlikte basit ve sade bir kart tasarımı kullanılmıştır.
                           Kartın altında yer alan "Çıkış Yap" butonu, kullanıcıya mevcut oturumunu sonlandırma imkanı sunmaktadır.
                           Sayfanın alt kısmında yer alan navigasyon çubuğu sayesinde ana sayfa, ekleme, detaylar, hesaplar ve bildirimler arasında kolayca geçiş yapılabilir.
                           Bu tasarım, kullanıcıların hesap bilgilerine hızlıca erişmesine ve güvenli bir şekilde oturum kapatmasına olanak tanıyan pratik bir yapı sunmaktadır. </p>
                    </div>
                    <div class="col-md-6 text-center">
                        <img src="{{ asset('images/hesaplar.png') }}" alt="hesap" class="img-fluid rounded shadow">
                    </div>
                </div>
            </div>
        </section>

    </section>

    <footer class="text-center py-4 bg-blue text-white mt-5">
        <p>&copy; 2025 ParanBurada A.Ş. Tüm hakları saklıdır.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
