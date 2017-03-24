//
//  Country.swift
//  My-Mo
//
//  Created by iDeveloper on 2/17/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation

class Country: NSObject {

    var array_Coutries: [String] = []
    var array_Cities: [Any] = []
    
    var Albania = [String]()
    var Algeria = [String]()
    var Andorra = [String]()
    var Angola = [String]()
    var AntiguaandBarbuda = [String]()
    var Argentina = [String]()
    var Armenia = [String]()
    var Australia = [String]()
    var Austria = [String]()
    var Azerbaijan = [String]()
    var Bahamas = [String]()
    var Bahrain = [String]()
    var Bangladesh = [String]()
    var Barbados = [String]()
    var Belarus = [String]()
    var Belgium = [String]()
    var Belize = [String]()
    var Benin = [String]()
    var Bhutan = [String]()
    var Bolivia = [String]()
    var BosniaandHerzegovina = [String]()
    var Botswana = [String]()
    var Brazil = [String]()
    var Brunei = [String]()
    var Bulgaria = [String]()
    var BurkinaFaso = [String]()
    var Burundi = [String]()
    var Cambodia = [String]()
    var Cameroon = [String]()
    var Canada = [String]()
    var CentralAfricanRepublic = [String]()
    var Chad = [String]()
    var China = [String]()
    var Colombia = [String]()
    var Comoros = [String]()
    var Congo = [String]()
    var CostaRica = [String]()
    var Cuba = [String]()
    var CotedIvoire = [String]()
    var Croatia = [String]()
    var Cyprus = [String]()
    var CzechRepublic = [String]()
    var Denmark = [String]()
    var Djibouti = [String]()
    var Dominica = [String]()
    var DominicanRepublic = [String]()
    var Ecuador = [String]()
    var Egypt = [String]()
    var EquatorialGuinea = [String]()
    var Eritrea = [String]()
    var Estonia = [String]()
    var Ethiopia = [String]()
    var Fiji = [String]()
    var Finland = [String]()
    var France = [String]()
    var Gabon = [String]()
    var Gambia = [String]()
    var Georgia = [String]()
    var GermString = [String]()
    var Ghana = [String]()
    var Greece = [String]()
    var Grenada = [String]()
    var Guatemala = [String]()
    var Guinea = [String]()
    var GuineaBissau = [String]()
    var Guyana = [String]()
    var Haiti = [String]()
    var Honduras = [String]()
    var Hungary = [String]()
    var Iceland = [String]()
    var India = [String]()
    var Indonesia = [String]()
    var Ireland = [String]()
    var Israel = [String]()
    var Italy = [String]()
    var Jamaica = [String]()
    var Japan = [String]()
    var Jordan = [String]()
    var Kazakhstan = [String]()
    var Kenya = [String]()
    var Kiribati = [String]()
    var Kuwait = [String]()
    var Kyrgyzstan = [String]()
    var Laos = [String]()
    var Latvia = [String]()
    var Lebanon = [String]()
    var Lesotho = [String]()
    var Lithuania = [String]()
    var Luxembourg = [String]()
    var Macedonia = [String]()
    var Madagascar = [String]()
    var Malawi = [String]()
    var Malasiya = [String]()
    var Maldives = [String]()
    var Mali = [String]()
    var Malta = [String]()
    var MarshallIsland = [String]()
    var Mauritania = [String]()
    var Mauritius = [String]()
    var Mexico = [String]()
    var Moldova = [String]()
    var Monaco = [String]()
    var Mongolia = [String]()
    var Montenegro = [String]()
    var Morocco = [String]()
    var Mozambique = [String]()
    var Myanmar = [String]()
    var Namibia = [String]()
    var Nepal = [String]()
    var Netherlands = [String]()
    var NewZealand = [String]()
    var Nicaragua = [String]()
    var Niger = [String]()
    var Nigeria = [String]()
    var Norway = [String]()
    var Oman = [String]()
    var Pakistan = [String]()
    var Palau = [String]()
    var Panama = [String]()
    var Papuanewguinea = [String]()
    var Paraguay = [String]()
    var Peru = [String]()
    var Philippines = [String]()
    var Poland = [String]()
    var Portugal = [String]()
    var Qatar = [String]()
    var Romania = [String]()
    var Russia = [String]()
    var Rwanda = [String]()
    var SaintKittsandNevis = [String]()
    var SaintLucia = [String]()
    var Samoa = [String]()
    var SanMarino = [String]()
    var SaoTomeandPrincipe = [String]()
    var SaudiArabia = [String]()
    var Senegal = [String]()
    var Serbia = [String]()
    var Seychelles = [String]()
    var SierraLeone = [String]()
    var Singapore = [String]()
    var Slovakia = [String]()
    var Slovenia = [String]()
    var Solomon = [String]()
    var Somalia = [String]()
    var SouthAfrica = [String]()
    var SouthKorea = [String]()
    var Spain = [String]()
    var SriLanka = [String]()
    var Suriname = [String]()
    var Sudan = [String]()
    var Sweden = [String]()
    var Switzerland = [String]()
    var Taiwan = [String]()
    var Tajikistan = [String]()
    var Tanzania = [String]()
    var Thailand = [String]()
    var TimorLeste = [String]()
    var Togo = [String]()
    var Tonga = [String]()
    var TrinidadandTobago = [String]()
    var Tunisia = [String]()
    var Turkey = [String]()
    var Turkmenistan = [String]()
    var Tuvalu = [String]()
    var Uganda = [String]()
    var Ukraine = [String]()
    var UnitedArabEmirates = [String]()
    var UnitedKingdom = [String]()
    var UnitedStates = [String]()
    
    func initCountries(){
        array_Coutries = ["Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "China", "Colombia", "Comoros", "Congo", "Costa Rica", "Cuba", "Cote d’Ivoire", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "GermString", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malasiya", "Maldives", "Mali", "Malta", "Marshall Island", "Mauritania", "Mauritius", "Mexico", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua new guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon", "Somalia", "South Africa", "South Korea", "Spain", "Sri Lanka", "Suriname", "Sudan", "Sweden", "Switzerland", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States"]
    }
    
    func initCities(){
        Albania = ["Durres", "Elbasan", "Fier-Cifci", "Korce", "Shkoder", "Tirana", "Vlore"]
        array_Cities.append(Albania)
        
        Algeria = ["Algiers", "Annaba", "Bab Ezzouar", "Batna", "Biskra", "Boumerdas", "Constantine", "Oran", "Setif", "Tebessa"]
        array_Cities.append(Algeria)
        
        Andorra = ["Andorra La Vella", "Arinsal", "Canillo", "El Pas de la Casa", "Encamp", "Escaldes-EngordString", "La Massana", "Ordino", "Santa Colom"]
        array_Cities.append(Andorra)
        
        Angola = ["Benguela", "Cuito", "Huambo", "Lobito", "Luanda", "Lubango", "Malanje", "N'dalatando", "Namibe"]
        array_Cities.append(Angola)
        
        AntiguaandBarbuda = ["All Saints", "Bolans", "Liberta", "Potter's Village", "Seaview Farm", "St. John's", "Swetes"]
        array_Cities.append(AntiguaandBarbuda)
        
        Argentina = ["Avellaneda", "Bahía Blanca", "Buenos Aires", "Comodoro Rivadavia", "Concordia", "Córdoba", "Corrientes", "La Plata", "Lanús", "Mar del Plata", "Mendoza", "Neuquén", "Quilmes", "Resistencia", "Rosario", "Salta", "San Juan", "San Salvador de Jujuy", "Santa Fe", "Santiago del Estero", "Tucumán"]
        array_Cities.append(Argentina)
        
        Armenia = ["Gyumri", "Vanadzor", "Yerevan"]
        array_Cities.append(Armenia)
        
        Australia = ["Adelaide", "Albury-Wodonga", "Ballarat", "Bendigo", "Brisbane", "Bunbury", "Bundaberg", "Cairns", "Canberra", "Coffs Harbour", "Darwin", "Geelong", "Gold Coast", "Hervey Bay", "Hobart", "Launceston", "Mackay", "Melbourne", "Newcastle", "Perth", "Rockhampton", "Sunshine Coast", "Sydney", "Toowoomba", "Townsville", "Wagga Wagga", "Wollongong"]
        array_Cities.append(Australia)
        
        Austria = ["Graz", "Innsbruck", "Klagenfurt am Woerthersee", "Linz", "Salzburg", "Vienna", "Villach", "Wels"]
        array_Cities.append(Austria)
        
        Azerbaijan = ["Baku", "Ganja", "Khirdalan", "Lankaran", "Mingachevir", "Shaki", "Shirvan", "Sumqayit", "Yevlakh"]
        array_Cities.append(Azerbaijan)
        
        Bahamas = ["Nassau"]
        array_Cities.append(Bahamas)
        
        Bahrain = ["Al Muharraq", "Ar Rifa'", "Dar Kulayb", "Madinat Hamad", "Manama"]
        array_Cities.append(Bahrain)
        
        Bangladesh = ["Chittagong", "Comilla", "Cox's Bazar", "Dhaka", "Jessore", "Khulna", "Narsingdi", "Rajshahi", "Rangpur", "Tungi"]
        array_Cities.append(Bangladesh)
        
        Barbados = ["Bridgetown"]
        array_Cities.append(Barbados)
        
        Belarus = ["Babruysk", "Baranovichi", "Brest", "Gomel", "Hrodna", "Mahilyow", "Minsk", "Orsha", "Pinsk", "Vitrbsk"]
        array_Cities.append(Belarus)
        
        Belgium = ["Antwerp", "Bruges", "Brussels", "Charleroi", "Ghent", "Namur"]
        array_Cities.append(Belgium)
        
        Belize = ["Belize City", "Belmopan"]
        array_Cities.append(Belize)
        
        Benin = ["Abomey", "Abomey-Calavi", "Bohicon", "Cotonou", "Djougou", "Kandi", "Lokossa", "Ouidah", "Parakou", "Porto-Novo"]
        array_Cities.append(Benin)
        
        Bhutan = ["Chhukha", "Daga", "Damphu", "Gasa Dzong", "Geylegphug", "Jakar", "Lhuntshi", "Mongar", "Paro", "Pemagatsel", "Phuntsholing", "Punakha", "Samdrup Jongkhar", "Samtse", "Taga Dzong", "Thimphu", "Tongsa", "Trashigang", "Wangdue Phodrang", "Zhemgang"]
        array_Cities.append(Bhutan)
        
        Bolivia = ["Cochabamba", "La Paz", "Montero", "Oruro", "Potosi", "Santa Cruz de la Sierra", "Sucre", "Tarija", "Trinidad", "Yacuiba"]
        array_Cities.append(Bolivia)
        
        BosniaandHerzegovina = ["Banja Luka", "Bihac", "Mostar", "Sarajevo", "Tuzla"]
        array_Cities.append(BosniaandHerzegovina)
        
        Botswana = ["Francistown", "Gaborone", "Molepolole", "Selebi-Phikwe"]
        array_Cities.append(Botswana)
        
        Brazil = ["Belem", "Belo Horizonte", "Brasilia", "Curitiba", "Fortaleza", "Manaus", "Recife", "Rio de Janeiro", "Salvador", "Sao Paulo"]
        array_Cities.append(Brazil)
        
        Brunei = ["Bandar Seri Begawan", "Kuala Belait", "Seria", "Tutong"]
        array_Cities.append(Brunei)
        
        Bulgaria = ["Burgas", "Dobrich", "Pleven", "Plovdiv", "Ruse", "Shumen", "Sliven", "Sofia", "Stara Zagora", "Varna"]
        array_Cities.append(Bulgaria)
        
        BurkinaFaso = ["Banfora", "Bobo-Dioulasso", "Koudougou", "Ouagadougou", "Ouahigouya"]
        array_Cities.append(BurkinaFaso)
        
        Burundi = ["Bujumbura", "Muyinga"]
        array_Cities.append(Burundi)
        
        Cambodia = ["Battambang", "Kampong Cham", "Kampong Speu", "Phnom Penh", "Prey Veng", "Pursat", "Siem Reap", "Sihanoukville", "Ta Khmau", "Takéo"]
        array_Cities.append(Cambodia)
        
        Cameroon = ["Bafoussam", "Bamenda", "Bertoua", "Douala", "Garoua", "Kousseri", "Maroua", "Mokolo", "Ngaoundere", "Yaounde"]
        array_Cities.append(Cameroon)
        
        Canada = ["Abbotsford, British Columbia", "Barrie, Ontario", "Calgary, Alberta", "Chicoutimi-Jonquière, Quebec", "Edmonton, Alberta", "Guelph, Ontario", "Halifax, Nova Scotia", "Hamilton, Ontario", "Kanata, Ontario", "Kelowna, British Columbia", "Kingston, Ontario", "Kitchener, Ontario", "London, Ontario", "Moncton, New Brunswick", "Montreal, Quebec", "Oshawa, Ontario", "Ottawa–Gatineau, Ontario/Quebec", "Quebec City, Quebec", "Regina, Saskatchewan", "Saint Joh", "Saskatoon, Saskatchewan", "Sherbrooke, Quebec", "St. Catharines–Niagara, Ontario", "St. John's, Newfoundland and Labrador", "Sudbury, Ontario", "Thunder Bay, Ontario", "Toronto, Ontario", "Trois-Rivières, Quebec", "Vancouver, British Columbia", "Victoria, British Columbia", "Windsor, Ontario", "Winnipeg, Manitoba"]
        array_Cities.append(Canada)
        
        CentralAfricanRepublic = ["Berberati", "Bertoua", "Bimbo", "Kaga Bandoro", "Mbaiki"]
        array_Cities.append(CentralAfricanRepublic)
        
        Chad = ["Abeche", "Kaga Bandoro", "Moundou", "Sagh"]
        array_Cities.append(Chad)
        
        China = ["Aksu", "Altay", "Anqing", "Anshan", "Stringang", "Baoding", "Baoji", "Bazhong", "Beihai", "Beijing", "Bengbu", "Benxi", "Binzhou", "Bozhou", "Cangzhou", "Changchun", "Changde", "Changsha", "Changshu", "Changzhou", "Chaozhou", "Chengdu", "Chifeng", "Chongqing", "Chuzhou", "Cixi", "Dalian", "Dandong", "DStringang", "Daqing", "Datong", "Dengzhou", "Dezhou", "Dingzhou", "Dongguan", "Dongying", "Ezhou", "Feicheng", "Foshan", "Fuqing", "Fushun", "Fuxin", "Fuyang", "Fuzhou", "Ganzhou", "Guigang", "Guilin", "Guiyang", "Haicheng", "Haikou", "Haimen", "Handan", "Hangzhou", "Harbin", "Hefei", "Hegang", "Hengyang", "Heze", "Hezhou", "Hohhot", "Hong Kong", "Huai'an", "Huaibei", "Huainan", "Huangshi", "Huazhou", "Huizhou", "Huludao", "Jiamusi", "Jiangmen", "Jiangyin", "Jiaozuo", "Jiaxing", "Jilin City", "Jinan", "Jingjiang", "Jingzhou", "Jinhua", "Jining", "Jinzhou", "Jiujiang", "Kaifeng", "Karamay", "Kashgar", "Kunming", "Laiwu", "Langfang", "Lanzhou", "Lhasa", "LiStringungang", "Liaocheng", "Liaoyang", "Lijiang", "Linfen", "Linhai", "Linyi", "Lishui", "Liuzhou", "Lu'an", "Luoyang", "Ma'anshan", "Macau", "Maoming", "MiStringang", "Mudanjiang", "Nanchang", "Nanchong", "Nanjing", "Nanning", "Nanping", "Nantong", "NStringang", "Neijiang", "Ningbo", "Panjin", "Panzhihua", "Pingdingshan", "Pizhou", "Putian", "Puyang", "Qidong", "Qingdao", "Qinhuangdao", "Qinhuangdao", "Qiqihar", "Quanzhou", "Qujing", "Rizhao", "Rugao", "Shanghai", "Shantou", "Shaoxing", "Shaoyang", "Shenyang", "Shenzhen", "Shijiazhuang", "Shouguang", "Suihua", "Suqian", "Suzhou", "Suzhou", "Tai'an", "Taixing", "Taiyuan", "Taizhou", "Taizhou", "Tangshan", "Tengzhou", "Tianjin", "Tianshui", "Tieling", "Ürümqi", "Weifang", "Weihai", "Wenling", "Wenzhou", "Wuchuan", "Wuhan", "Wuhu", "Wuwei", "Wuxi", "Xi'an", "Xiamen", "Xiangcheng", "Xiangtan", "Xiangyang", "XiStringang", "Xingtai", "Xining", "Xinxiang", "Xinyang", "Xinyi", "Xuchang", "Xuzhou", "Yancheng", "Yangjiang", "Yangzhou", "Yantai", "Yibin", "Yichang", "Yinchuan", "Yingkou", "Yiwu", "Yiwu", "Yixing", "Yueyang", "Yulin", "Yuzhou", "Zaoyang", "Zaozhuang", "Zhangjiagang", "Zhangqiu", "Zhangzhou", "Zhanjiang", "Zhaoqing", "Zhengzhou", "Zhenjiang", "Zhongshan", "Zhoukou", "Zhoushan", "Zhucheng", "Zhuhai", "Zhuji", "Zhuzhou", "Zibo", "Zigong", "Zoucheng", "Zunyi"]
        array_Cities.append(China)
        
        Colombia = ["Barranquilla", "Bogota", "Bucaramanga", "Cali", "Cartagena", "Cucuta", "Ibague", "Medellin", "Pereira", "Santa Marta"]
        array_Cities.append(Colombia)
        
        Comoros = ["Abeche", "Adda-Douéni", "Bambao", "Bazimini", "Domoni", "Fomboni", "Jimilimé", "Koni-Djodjo", "Mirontsi", "Moya", "Mramani", "Mutsamudu"]
        array_Cities.append(Comoros)
        
        Congo = ["Brazzaville", "Bukavu", "Dolisie", "Kananga", "Kayes", "Kinshasa", "Kisangani", "Kolwezi", "Likasi", "Lubumbashi", "Masina", "Mbuji-Mayi", "Pointe-Noire", "Tshikapa"]
        array_Cities.append(Congo)
        
        CostaRica = ["Limon", "San Francisco", "San Jose"]
        array_Cities.append(CostaRica)
        
        Cuba = ["Arroyo Naranjo", "Bayamo", "Camaguey", "Diez de Octubre", "Guantanamo", "Havana", "Holguin", "Las Tunas", "Santa Clara", "Santiago de Cuba"]
        array_Cities.append(Cuba)
        
        CotedIvoire = ["Abidjan", "Abobo", "Bouake", "Daloa", "Divo", "Gagnoa", "Korhogo", "Man", "San-Pedro", "Yamoussoukro"]
        array_Cities.append(CotedIvoire)
        
        Croatia = ["Osijek", "Pula", "Rijeka", "Sesvete", "Slavonski Brod", "Split", "Zadar", "Zagreb", "Zagreb - Centar"]
        array_Cities.append(Croatia)
        
        Cyprus = ["Aradíppou", "Famagusta", "Kyrenia", "Larnaca", "Limassol", "Mórfou", "Nicosia", "Paphos", "Pérgamos", "Protaras"]
        array_Cities.append(Cyprus)
        
        CzechRepublic = ["Brno", "Ceske Budejovice", "Hradec Kralove", "Liberec", "Olomouc", "Ostrava", "Pardubice", "Pilsen", "Prague", "Usti nad Labem"]
        array_Cities.append(CzechRepublic)
        
        Denmark = ["Aalborg", "Arhus", "Copenhagen", "Esbjerg", "Frederiksberg", "Horsens", "Kolding", "Odense", "Randers", "Vejle"]
        array_Cities.append(Denmark)
        
        Djibouti = ["Ali Sabih", "Danan", "Djibouti", "Obock", "Tadjoura"]
        array_Cities.append(Djibouti)
        
        Dominica = ["Roseau"]
        array_Cities.append(Dominica)
        
        DominicanRepublic = ["Bella Vista", "La Romana", "Puerto Plata", "Salvaleon de Higuey", "San Cristobal", "San Francisco de Macoris", "San Pedro de Macoris", "Santiago de los Caballeros", "Santo Domingo", "Santo Domingo Oeste"]
        array_Cities.append(DominicanRepublic)
        
        Ecuador = ["Ambato", "Cuenca", "Eloy Alfaro", "Esmeraldas", "Guayaquil", "Machala", "Manta", "Portoviejo", "Quito", "Santo Domingo de los Colorados"]
        array_Cities.append(Ecuador)
        
        Egypt = ["Al Jizah", "Al Mahallah al Kubra", "Al Mansurah", "Alexandria", "Asyut", "Cairo", "Luxor", "Port Said", "Suez", "Tanda"]
        array_Cities.append(Egypt)
        
        EquatorialGuinea = ["Bata", "Malabo"]
        array_Cities.append(EquatorialGuinea)
        
        Eritrea = ["Asmara", "Keren"]
        array_Cities.append(Eritrea)
        
        Estonia = ["Narva", "Tallinn", "Tartu"]
        array_Cities.append(Estonia)
        
        Ethiopia = ["Addis Ababa", "Bahir Dar", "Bishoftu", "Dese", "Dire Dawa", "Gondar", "Hawassa", "Jima", "Mekele", "Nazret"]
        array_Cities.append(Ethiopia)

        Fiji = ["Lautoka", "Suva"]
        array_Cities.append(Fiji)
        
        Finland = ["Espoo", "Helsinki", "Jyvaeskylae", "Kuopio", "Lahti", "Oulu", "Pori", "Tampere", "Turku", "Vantaa"]
        array_Cities.append(Finland)
        
        France = ["Aix en Provence", "Amiens", "Angers", "Argenteuil", "Asnieres-sur-Seine", "Aulnay-sous-Bois", "Avignon", "Besançon", "Bordeaux", "Boulogne-Billancourt", "Brest", "Caen", "Calais", "Clermont-Ferrand", "Colombes", "Créteil", "Dijon", "Fort-de-France", "Grenoble", "La Rochelle", "Le Havre", "Le Mans", "Lille", "Limoges", "Lyon", "Marseilles", "Metz", "Montpellier", "Montreuil", "Mulhouse", "Nancy", "Nanterre", "Nantes", "Nice", "Nîmes", "Orleans", "Paris", "Pau", "Perpignan", "Poitiers", "Reims", "Rennes", "Roubaix", "Rouen", "Saint Etienne", "St Denis", "St Denis", "St.Paul", "Strasbourg", "Toulon", "Toulouse", "Tourcoing", "Tours", "Versailles", "Villeurbanne", "Vitry-sur-Seine"]
        array_Cities.append(France)
        
        Gabon = ["Libreville", "Port-Gentil"]
        array_Cities.append(Gabon)
        
        Gambia = ["Brikama"]
        array_Cities.append(Gambia)
        
        Georgia = ["AlbString", "Athens", "Atlanta", "Columbus", "Macon", "Roswell", "Sandy Springs", "Savannah"]
        array_Cities.append(Georgia)
        
        GermString = ["Berlin", "Bremen", "Dortmund", "Dusseldorf", "Essen", "Frankfurt am Main", "Hamburg", "Koeln", "Munich", "Stuttgart"]
        array_Cities.append(GermString)
        
        Ghana = ["Accra", "Achiaman", "Cape Coast", "Kumasi", "Obuasi", "Sekondi-Takoradi", "Takoradi", "Tamale", "Tema", "Teshi Old Town"]
        array_Cities.append(Ghana)
        
        
        Greece = ["Acharnes", "Athens", "Irakleion", "Kalamaria", "Kallithea", "Larisa", "Patra", "Peristeri", "Piraeus", "Thessaloniki"]
        array_Cities.append(Greece)
        
        Grenada = ["Grenville", "St. George's"]
        array_Cities.append(Grenada)
        
        Guatemala = ["Chimaltenango", "Chinautla", "Escuintla", "Guatemala City", "Mixco", "Petapa", "Quetzaltenango", "San Juan Sacatepequez", "Villa Canales", "Villa Nueva"]
        array_Cities.append(Guatemala)
        
        Guinea = ["Camayenne", "Conakry", "Coyah", "Gueckedou", "Kamsar", "Kankan", "Kindia", "Labe"]
        array_Cities.append(Guinea)
        
        GuineaBissau = ["Bissau"]
        array_Cities.append(GuineaBissau)
        
        Guyana = ["Georgetown"]
        array_Cities.append(Guyana)
        
        Haiti = ["Carrefour", "Croix des Bouquets", "Delmas 73", "Jacmel", "Leogane", "Les Cayes", "Okap", "Petionville", "Port-au-Prince", "Port-de-Paix"]
        array_Cities.append(Haiti)
        
        Honduras = ["Choloma", "Ciudad Choluteca", "Comayagua", "El Progreso", "La Ceiba", "San Pedro Sula", "Tegucigalpa"]
        array_Cities.append(Honduras)
        
        Hungary = ["Budapest", "Budapest III. keruelet", "Budapest XI. keruelet", "Budapest XIV. keruelet", "Debrecen", "Gyor", "Miskolc", "Nyiregyhaza", "Pecs", "Szeged"]
        array_Cities.append(Hungary)
        
        Iceland = ["Akranes", "Akureyri", "Álftanes", "Garðabær", "Grindavík", "Hafnarfjörður", "Ísafjörður", "Keflavík", "Mosfellsbær", "Njarðvík", "Reykjavik", "Sauðárkrókur", "Selfoss", "Seltjarnarnes", "Vestmannaeyjar"]
        array_Cities.append(Iceland)
        
        India = ["Agra", "Ahmadabad", "Allahabad", "Amritsar", "Asansol", "Bangalore", "Bhopal", "Chennai", "Coimbatore", "Delhi", "Dhanbad", "Faridabad", "Hyderabad", "Indore", "Jabalpur", "Jaipur", "Jamshedpur", "Kanpur", "Kochi", "Kolkata (Calcutta)", "Lucknow", "Ludhiana", "Madurai", "Meerut", "Mumbai (Bombay)", "Nagpur", "Nashik", "Patna", "Pune", "Rajkot", "Surat", "Vadodara", "Varanasi", "Vijayawada", "Visakhapatnam"]
        array_Cities.append(India)
        
        Indonesia = ["Bandung", "Bekasi", "Jakarta", "Makassar", "Medan", "Palembang", "Semarang", "South Tangerang", "Surabaya", "Tangerang"]
        array_Cities.append(Indonesia)
        
        Ireland = ["Cork", "Dublin", "Dun Laoghaire", "Gaillimh", "Luimneach", "Tallaght"]
        array_Cities.append(Ireland)
        
        Israel = ["Ashdod", "Beersheba", "Haifa", "Holon", "Jerusalem", "NetStringa", "Petah Tiqwa", "Rishon LeZiyyon", "Tel Aviv", "West Jerusalem"]
        array_Cities.append(Israel)
        
        Italy = ["ancon", "Bari", "Bologna", "Brescia", "Cagliari", "Catania", "Florence", "Genoa", "Lecce", "Messina - Reggio Calabria", "Milan", "Modena", "Naples", "Palermo", "Parma", "Perugia", "Pescara", "Pisa - Livorno", "Reggio Emilia", "Rimini", "Rome", "Taranto", "Trieste", "Turin", "Venice - Padua", "Verona", "Versilia", "Vicenza"]
        array_Cities.append(Italy)
        
        Jamaica = ["Kingston", "Montego Bay", "New Kingston", "Portmore", "Spanish Town"]
        array_Cities.append(Jamaica)
        
        Japan = ["Chiba", "Fukuoka", "Hiroshima", "Kawasaki", "Kitakyushu", "Kobe", "Kyoto", "Nagoya", "Osaka", "Saitama", "Sapporo", "Sendai", "Tokyo", "Yokohama"]
        array_Cities.append(Japan)
        
        Jordan = ["'Ajlun", "Amman", "Aqaba", "Ar Ramtha", "As Salt", "Irbid", "Madaba", "Russeifa", "Wadi as Sir", "Zarqa"]
        array_Cities.append(Jordan)
        
        Kazakhstan = ["'Almaty", "Astana", "Karagandy", "Kyzyl-Orda", "Kyzylorda", "Pavlodar", "Semey", "Shymkent", "Taraz", "Ust-Kamenogorsk"]
        array_Cities.append(Kazakhstan)
        
        Kenya = ["Eldoret", "Garissa", "Kakamega", "Kisumu", "Kitale", "Malindi", "Mombasa", "Nairobi", "Nakuru", "Thika"]
        array_Cities.append(Kenya)
        
        Kiribati = ["South Tarawa"]
        array_Cities.append(Kiribati)
        
        Kuwait = ["Al Ahmadi", "Al Fahahil", "Al Farwaniyah", "Ar Riqqah", "Ar Rumaythiyah", "As Salimiyah", "Hawalli", "Kuwait City", "Sabah as Salim"]
        array_Cities.append(Kuwait)
        
        Kyrgyzstan = ["Bishkek", "Jalal-Abad", "Kara-Balta", "Karakol", "Naryn", "Osh", "Tokmok"]
        array_Cities.append(Kyrgyzstan)
        
        Laos = ["Pakxe", "Savannakhet", "Vientianek"]
        array_Cities.append(Laos)
        
        Latvia = ["Daugavpils", "Jelgava", "Jurmala", "Liepaja", "Riga", "Vec-Liepaja"]
        array_Cities.append(Latvia)
        
        Lebanon = ["Aley", "Beirut", "Byblos", "Habbouch", "Jounieh", "Shheem", "Sidon", "Tripoli", "Tyre"]
        array_Cities.append(Lebanon)
        
        Lesotho = ["Kakamega", "Mafeteng"]
        array_Cities.append(Lesotho)
        
        Lithuania = ["Alytus", "Dainava (Kaunas)", "Eiguliai", "Kaunas", "Klaipeda", "Panevezys", "Siauliai", "Vilnius"]
        array_Cities.append(Lithuania)
        
        Luxembourg = ["Luxembourg"]
        array_Cities.append(Luxembourg)

        Macedonia = ["Bitola", "Cair", "Gostivar", "Kisela Voda", "Kumanovo", "Ohrid", "Prilep", "Skopje", "Tetovo", "Veles"]
        array_Cities.append(Macedonia)
        
        Madagascar = ["Ambilobe", "Ambovombe", "Antananarivo", "Antanifotsy", "Antsirabe", "Antsiranana", "Fianarantsoa", "Mahajanga", "Toamasina", "Toliara"]
        array_Cities.append(Madagascar)
        
        Malawi = ["Blantyre", "Lilongwe", "Mzuzu", "Zomba"]
        array_Cities.append(Malawi)
        
        Malasiya = ["Alor Setar", "George Town", "Ipoh", "Johor Bahru", "Kota Kinabalu", "Kuala Lumpur", "Kuala Terengganu", "Kuching", "Malacca City", "Miri", "Penang Island", "Petaling Jaya", "Shah Alam"]
        array_Cities.append(Malasiya)
        
        Maldives = ["Fuvahmulah", "Hithadhoo", "Kulhudhuffushi", "Malé"]
        array_Cities.append(Maldives)
        
        Mali = ["Bamako", "Gao", "Kayes", "Koutiala", "Markala", "Mopti", "Segou", "Sikasso"]
        array_Cities.append(Mali)
        
        Malta = ["Birgu", "Bormla", "Mdina", "Qormi", "Rabat", "Senglea", "Siġġiewi", "Valetta", "Żabbar", "Żebbuġ", "Żejtun"]
        array_Cities.append(Malta)
        
        MarshallIsland = ["Arno", "Ebaye", "Jabor", "Majuro", "Wotje"]
        array_Cities.append(MarshallIsland)
        
        Mauritania = ["Kaedi", "Nema", "Nouadhibou", "Nouakchott"]
        array_Cities.append(Mauritania)
        
        Mauritius = ["Curepipe", "Port Louis", "Quatre Bornes", "Vacoas"]
        array_Cities.append(Mauritius)
        
        Mexico = ["Acapulco", "Aguascalientes", "Cancún", "Celaya", "Chihuahua", "Chimalhuacán", "Ciudad Apodaca", "Ciudad López Mateos", "Cuautitlán Izcalli", "Cuernavaca", "Culiacán", "Durango", "Ecatepec", "General Escobedo", "Guadalajara", "Guadalupe", "Hermosillo", "Irapuato", "Ixtapaluca", "Juárez", "León", "Matamoros", "Mazatlán", "Mérida", "Mexicali", "Mexico City", "Monterrey", "Morelia", "Naucalpan", "Nezahualcóyotl", "Nuevo Laredo", "Puebla", "Querétaro", "Reynosa", "Saltillo", "San Luis Potosí", "San Nicolás de los Garza", "Tepic", "Tijuana", "Tlalnepantla", "Tlaquepaque", "Toluca", "Tonalá", "Torreón", "Tuxtla Gutiérrez", "Veracruz", "Villahermosa", "Xalapa", "Xico", "Zapopan"]
        array_Cities.append(Mexico)
        
        Moldova = ["Balti", "Bender", "Chisinau", "Ribnita", "Tiraspolul"]
        array_Cities.append(Moldova)
        
        Monaco = ["Fontvieille", "La Condamine", "Monaco", "Monte Carlo"]
        array_Cities.append(Monaco)
        
        Mongolia = ["Darhan", "Erdenet", "Khovd", "Olgii", "Ulaanbaatar"]
        array_Cities.append(Mongolia)
        Montenegro = ["Niksic", "Podgorica"]
        array_Cities.append(Montenegro)
        Morocco = ["Agadir", "Al Hoceima", "Casablanca", "Fes", "Marrakesh", "Meknes", "Oujda", "Rabat", "Sale", "Tangier"]
        array_Cities.append(Morocco)
        Mozambique = ["Beira", "Chimoio", "Maputo", "Maxixe", "Nacala", "Nampula", "Quelimane", "Tete", "Xai-Xai"]
        array_Cities.append(Mozambique)
        Myanmar = ["Bago", "Mandalay", "Mawlamyine", "Meiktila", "Mergui", "Monywa", "Naypyidaw (Nay Pyi Taw)", "Pathein", "Pyay", "Sittwe", "Taunggyi", "Yangon (Rangoon)"]
        array_Cities.append(Myanmar)
        
        Namibia = ["Rundu", "Walvis Bay", "Windhoek"]
        array_Cities.append(Namibia)
        Nepal = ["Bharatpur", "Biratnagar", "Birganj", "Butwal", "Dhangarhi", "Dharan Bazar", "Janakpur", "Kathmandu", "Patan", "Pokhara"]
        array_Cities.append(Nepal)
        Netherlands = ["Almere Stad", "Amsterdam", "Breda", "Eindhoven", "Groningen", "Nijmegen", "Rotterdam", "The Hague", "Tilburg", "Utrecht"]
        array_Cities.append(Netherlands)
        NewZealand = ["Auckland", "Christchurch", "Dunedin", "Gisborne", "Hamilton", "Invercargill", "Napier-Hastings", "Nelson", "New Plymouth", "Palmerston North", "Rotorua", "Tauranga", "Wellington", "Whanganui", "Whangarei"]
        array_Cities.append(NewZealand)
        
        Nicaragua = ["Chinandega", "Ciudad Sandino", "Esteli", "Granada", "Juigalpa", "Leon", "Managua", "Masaya", "Matagalpa", "Tipitapa"]
        array_Cities.append(Nicaragua)
        Niger = ["Agadez", "Alaghsas", "Maradi", "Niamey", "Tahoua", "Zinder"]
        array_Cities.append(Niger)
        Nigeria = ["Abuja", "Calabar", "Enugu", "Ibadan", "Jos", "Kano", "Lagos", "Minna", "Port Harcourt", "Uyo", "Warri"]
        array_Cities.append(Nigeria)
        Norway = ["Bergen", "Drammen", "Fredrikstad", "Kristiansand", "Oslo", "Sandnes", "Sarpsborg", "Stavanger", "Tromso", "Trondheim"]
        array_Cities.append(Norway)
        
        Oman = ["`Ibri", "Al Sohar", "As Sib al Jadidah", "As Suwayq", "Barka'", "Bawshar", "Muscat", "Rustaq", "Saham", "Salalah"]
        array_Cities.append(Oman)
        Pakistan = ["Faisalabad", "Gujranwala", "Hyderabad", "Karachi", "Lahore", "Multan", "Muzaffarabad", "Peshawar", "Quetta", "Rawalpindi"]
        array_Cities.append(Pakistan)
        Palau = ["Koror."]
        array_Cities.append(Palau)
        Panama = ["Arraijan", "Colon", "David", "La Chorrera", "La Chorrera", "Las Cumbres", "Panama", "San Miguelito", "Tocumen"]
        array_Cities.append(Panama)
        
        
        Papuanewguinea = ["Lae", "Port Moresby"]
        array_Cities.append(Papuanewguinea)
        Paraguay = ["Asuncion", "Capiata", "Ciudad del Este", "Encarnacion", "Fernando de la Mora", "Lambare", "Limpio", "Nemby", "Pedro Juan Caballero", "San Lorenzo"]
        array_Cities.append(Paraguay)
        Peru = ["Arequipa", "Callao", "Chiclayo", "Chimbote", "Cusco", "Huancayo", "Iquitos", "Lima", "Piura", "Trujillo"]
        array_Cities.append(Peru)
        Philippines = ["Antipolo", "Budta", "Cebu City", "Davao", "General Santos", "Malingao", "Manila", "Pasig City", "Quezon City", "Taguig"]
        array_Cities.append(Philippines)
        
        Poland = ["Bydgoszcz", "Gdansk", "Katowice", "Krakow", "Lodz", "Lublin", "Poznan", "Szczecin", "Warsaw", "Wroclaw"]
        array_Cities.append(Poland)
        Portugal = ["Amadora", "Braga", "Coimbra", "Funchal", "Funchal", "Lisbon", "Porto", "Queluz", "Setubal", "Vila Nova de Gaia"]
        array_Cities.append(Portugal)
        Qatar = ["Al Khor", "Al Wakrah", "Ar Rayyan", "doha"]
        array_Cities.append(Qatar)
        Romania = ["Braila", "Brasov", "Bucharest", "Cluj-Napoca", "Constanta", "Craiova", "Galati", "Iasi", "Ploiesti", "Timisoara"]
        array_Cities.append(Romania)
        
        Russia = ["Chelyabinsk", "Izhevsk", "Kazan", "Moscow", "Nizhniy Novgorod", "Novosibirsk", "Omsk", "Rostov-na-Donu", "Saint Petersburg", "Samara", "Saratov", "Ulyanovsk", "Yekaterinburg"]
        array_Cities.append(Russia)
        Rwanda = ["Butare", "Byumba", "Cyangugu", "Gisenyi", "Gitarama", "Kigali", "Musanze"]
        array_Cities.append(Rwanda)
        SaintKittsandNevis = ["Basseterre", "Saint Thomas Lowland"]
        array_Cities.append(SaintKittsandNevis)
        SaintLucia = ["Castries"]
        array_Cities.append(SaintLucia)
        Samoa = ["Apia", "Salelologa"]
        array_Cities.append(Samoa)
        SanMarino = ["San Marino"]
        array_Cities.append(SanMarino)
        
        SaoTomeandPrincipe = ["Sao Tome"]
        array_Cities.append(SaoTomeandPrincipe)
        SaudiArabia = ["Abha", "Al Qunfudhah", "Buraydah", "Dammam", "Hofuf", "Jeddah", "Jubail", "Khamis Mushait", "Khobar", "Mecca", "Medina", "Najran", "Qatif", "Riyadh", "Sultanah", "Ta'if", "Tabuk", "Yanbu"]
        array_Cities.append(SaudiArabia)
        Senegal = ["Dakar", "Kaolack", "Mbake", "Pikine", "Saint-Louis", "Tambacounda", "Thies Nones", "Tiebo", "Touba", "Ziguinchor"]
        array_Cities.append(Senegal)
        Serbia = ["Belgrade", "Cacak", "Kragujevac", "Kraljevo", "Leskovac", "Nis", "Novi Pazar", "Novi Sad", "Zemun"]
        array_Cities.append(Serbia)
        
        Seychelles = ["Anse Boileau", "Beau Vallon", "Takamaka", "Victoria"]
        array_Cities.append(Seychelles)
        SierraLeone = ["Bo", "Freetown", "Kenema", "Koidu", "Makeni"]
        array_Cities.append(SierraLeone)
        Singapore = ["Singapore"]
        array_Cities.append(Singapore)
        Slovakia = ["Banska Bystrica", "Bratislava", "Kosice", "Martin", "Nitra", "Poprad", "Presov", "Trencin", "Trnava", "Zilina"]
        array_Cities.append(Slovakia)
        Slovenia = ["Ljubljana", "Maribor"]
        array_Cities.append(Slovenia)
        Solomon = ["Auki", "Buala", "Gizo", "Honiara"]
        array_Cities.append(Solomon)
        Somalia = ["Afgooye", "Baidoa", "Berbera", "Bosaso", "Burao", "Hargeysa", "Jamaame", "Kismayo", "Marka", "Mogadishu"]
        array_Cities.append(Somalia)
        
        SouthAfrica = ["Bloemfontein", "Cape Town", "Carletonville", "Chatsworth", "Durban", "Ibhayi", "Johannesburg", "Katlehong", "Khayelitsha", "Mabopane", "Mamelodi", "Mitchell's Plain", "Nelspruit", "Pietermaritzburg", "Polokwane", "Port Elizabeth", "Pretoria", "Rustenburg", "Sebokeng", "Soshanguve", "Soweto", "Tembisa", "Tshivhase", "Umlazi"]
        array_Cities.append(SouthAfrica)
        SouthKorea = ["Bucheon-si", "Busan", "Daegu", "Daejeon", "Goyang-si", "Incheon", "Sejong", "Seongnam-si", "Seoul", "Suwon-si", "Ulsan"]
        array_Cities.append(SouthKorea)
        
        Spain = ["A Coruña", "Alcalá de Henares", "Alicante", "Alicante", "Almería", "Andalusia", "Antequera", "Aragon", "Badalona", "Barcelona", "Baza", "Benalmádena", "Benidorm", "Bilbao", "Blanes", "Burgos", "Cádiz", "Carmona", "Cartagena", "Catalonia", "Ceuta", "Córdoba", "Costa Blanca", "Costa Brava", "Costa calida", "Costa de la Luz", "Costa del sol spain", "Dénia", "Ejea de los Caballeros", "Elche", "Fuengirola", "Galicia", "Gibraltar", "Gijón", "Gijón", "Girona", "Girona spain", "Granada", "Huelva", "Jerez", "Jerez de la Frontera", "L'Hospitalet de Llobregat", "La manga", "La Orotava", "Las Palmas", "Lleida", "Logroño", "Los Realejos", "Madrid", "Málaga", "Marbella", "Mérida", "Mijas", "Nerja", "Northern spain", "Oviedo", "Oviedo spain", "Palma, Majorca", "Pamplona", "Puerto de la Cruz", "Ronda", "Salou", "San Sebastian", "Santa Cruz de Tenerife", "Santander spain", "Santiago", "Scuba", "Segovia", "Seville", "Sierra Nevada", "Tarragona spain", "Toledo", "Valencia", "Vilanova i la Geltrú", "Vizcaya", "Zaragoza"]
        array_Cities.append(Spain)
        
        SriLanka = ["Colombo", "Galkissa", "Jaffna", "Kalmunai", "Kandy", "Moratuwa", "Negombo", "Pita Kotte", "Sri Jayewardenepura Kotte", "Trincomalee"]
        array_Cities.append(SriLanka)
        Suriname = ["Paramaribo"]
        array_Cities.append(Suriname)
        Sudan = ["Al Qadarif", "El Daein", "El Fasher", "El Obeid", "Kassala", "Khartoum", "Kosti", "Omdurman", "Port Sudan", "Wad Medani"]
        array_Cities.append(Sudan)
        Sweden = ["Goeteborg", "Helsingborg", "Huddinge", "Jonkoping", "Linkoping", "Malmoe", "Orebro", "Stockholm", "Uppsala", "Vasteras"]
        array_Cities.append(Sweden)
        
        Switzerland = ["Basel", "Bern", "Geneve", "Lausanne", "Luzern", "Sankt Gallen", "Winterthur", "Zuerich (Kreis 11)", "Zurich"]
        array_Cities.append(Switzerland)
        Taiwan = ["Banqiao", "Hsinchu", "Hualian", "Kaohsiung", "Keelung", "Taichung", "Tainan", "Taipei", "Taitung City", "Taoyuan City"]
        array_Cities.append(Taiwan)
        Tajikistan = ["Dushanbe", "Istaravshan", "Khujand", "Konibodom", "Kulob", "Qurghonteppa"]
        array_Cities.append(Tajikistan)
        Tanzania = ["Arusha", "Dar es Salaam", "Dodoma", "Kigoma", "Mbeya", "Morogoro", "Moshi", "Mwanza", "Tanga", "Zanzibar"]
        array_Cities.append(Tanzania)
        
        Thailand = ["Bangkok", "Chiang Mai", "Chon Buri", "Hat Yai", "Mueang Nonthaburi", "Nakhon Ratchasima", "Pak Kret", "Samut Prakan", "Si Racha", "Udon Thani"]
        array_Cities.append(Thailand)
        TimorLeste = ["Aileu", "Baucau", "Dili", "Liquica", "Maliana", "Same", "Suai"]
        array_Cities.append(TimorLeste)
        Togo = ["Atakpame", "Bassar", "Kara", "Kpalime", "Lome", "Sokode", "Tsevie"]
        array_Cities.append(Togo)
        Tonga = ["Neiafu", "Nuku'alofa"]
        array_Cities.append(Tonga)
        TrinidadandTobago = ["Chaguanas", "Laventille", "Mon Repos", "San Fernando"]
        array_Cities.append(TrinidadandTobago)
        
        Tunisia = ["Ariana", "Bizerte", "Gabes", "Gafsa", "Kairouan", "Kasserine", "Midoun", "Sfax", "Sousse", "Tunis"]
        array_Cities.append(Tunisia)
        Turkey = ["Adana", "Ankara", "Antalya", "Bagcilar", "Bursa", "Cankaya", "Denizli", "Diyarbakır", "Eskişehir", "Gaziantep", "İskenderun", "Istanbul", "Izmir", "Kayseri", "Konya", "Malatya", "Mersin", "Samsun"]
        array_Cities.append(Turkey)
        
        Turkmenistan = ["Ashgabat", "Balkanabat", "Bayramaly", "Dasoguz", "Mary", "Tejen", "Turkmenabat", "Turkmenbasy"]
        array_Cities.append(Turkmenistan)
        Tuvalu = ["Funafuti"]
        array_Cities.append(Tuvalu)
        Uganda = ["Bwizibwera", "Gulu", "Jinja", "Kampala", "Kasese", "Lira", "Masaka", "Mbale", "Mbarara", "Mukono"]
        array_Cities.append(Uganda)
        Ukraine = ["Dnipropetrovsk", "Donetsk", "Jonkoping", "Kharkiv", "Kryvyi Rih", "L'viv", "Mariupol", "Mykolayiv", "Odessa", "Zaporizhzhya"]
        array_Cities.append(Ukraine)
        
        UnitedArabEmirates = ["Abu Dhabi", "Ajman", "Dubai", "Fujairah", "Ras Al Khaimah", "Sharjah", "Umm Al Quwain"]
        array_Cities.append(UnitedArabEmirates)

        UnitedKingdom = ["Aberdeen", "Aberdeenshire", "Amber Valley", "Angus", "Arun", "Ashfield", "Aylesbury Vale", "Barnsley", "Basildon", "Basingstoke & Deane", "Bassetlaw", "Bath & North East Somerset", "Bedford", "Belfast", "Birmingham", "Blackburn", "Blackpool", "Bolton", "Bournemouth", "Bracknell Forest", "Bradford", "Braintree", "Breckland", "Bridgend", "Brighton", "Bristol", "Broadland", "Broxtowe", "Bury", "Caerphilly", "Calderdale", "Cambridge", "Canterbury", "Cardiff", "Carmarthenshire", "Charnwood", "Chelmsford", "Cheltenham", "Cherwell", "Chester", "Colchester", "Conway", "Coventry", "Crewe & Nantwich", "Dacorum", "Derby", "Doncaster", "Dover", "Dubley", "Dumfries & Galloway", "Dundee", "East Ayrshire", "East Devon", "East Dunbartonshire", "East Hampshire", "East Hertfordshire", "East Lindsey", "East Riding", "Eastleigh", "Edinburgh", "Elmbridge", "Epping Forest", "Erewash", "Exeter", "Falkirk", "Fife", "Flintshire", "Gateshead", "Gedling", "Glasgow", "Gloucester", "Guildford", "Gwynedd", "Halton", "Harrogate", "Havant & Waterloo", "Highland", "Horsham", "Huntingdonshire", "Ipswich", "Isle of Wight", "Kings Lynn & West Norfolk", "Kingston-upon-Hull", "Kirklees", "Knowsley", "Lancaster", "Leeds", "Leicester", "Lisburn", "Liverpool", "London", "Luton", "Macclesfield", "Maidstone", "Manchester", "Mid Bedfordshire", "Mid Sussex", "Middlesbrough", "Milton Keynes", "Neath Port Talbot", "New Forest", "Newbury", "Newcastle-under-Lyme", "Newcastle-upon-Tyne", "Newport", "North Ayrshire", "North East Lincolnshire", "North Hertfordshire", "North Lanarkshire", "North Lincolnshire", "North Somerset", "North Tyneside", "North Wiltshire", "Northampton", "Norwich", "Nottingham", "Nuneaton & Bedworth", "Oldham", "Oxford", "Pembrokeshire", "Perth & Kinross", "Peterborough", "Plymouth", "Poole", "Portsmouth", "Powys", "Preston", "Reading", "Redcar & Cleveland", "Reigate & Banstead", "Renfrewshire", "Rhondda, Cynon, Taff", "Rochdale", "Rochester-upon-Medway", "Rotherham", "Salford", "Salisbury", "Sandwell", "Scarborough", "Scottish Borders", "Sefton", "Sevenoaks", "Sheffield", "Slough", "Solihull", "South Ayrshire", "South Bedfordshire", "South Cambridgeshire", "South Gloucestershire", "South Kesteven", "South Lanarkshire", "South Oxfordshire", "South Somerset", "South Tyneside", "Southampton", "Southend-on-Sea", "St Albans", "St Helens", "Stafford", "Stockport", "Stockton-on-Tees", "Stoke-on-Trent", "Stratford-on-Avon", "Stroud", "Suffolk Coastal", "Sunderland", "Swale", "Swansea", "Tameside", "Teignbridge", "Tendring", "Test Valley", "Thamesdown", "Thanet", "The Wrekin", "Thurrock", "Torbay", "Trafford", "Vale of Glamorgan", "Vale of White Horse", "Vale Royal", "Wakefiled", "Walsall", "Warrington", "Warwick", "Waveney", "Waverley", "Wealden", "West Lancashire", "West Lothian", "West Wiltshire", "Wigan", "Windsor & Maidenhead", "Wirral", "Wokingham", "Wolverhampton", "Wrexham Maelor", "Wychavon", "Wycombe", "York"]
        array_Cities.append(UnitedKingdom)
        
        UnitedStates = ["Albuquerque, N.M.", "Arlington,", "Atlanta , Ga.", "Austin", "Baltimore, Md.", "Boston, Mass.", "Charlotte, N.C.", "Chicago", "Cleveland, Ohio", "Colorado Springs, Colo.", "Columbus, Ohio", "Dallas", "Denver , Colo.", "Detroit, Mich.", "El Paso, Tex.", "Fort Worth , Tex.", "Fresno, Calif.", "Houston", "Indianapolis, Ind.", "Jacksonville", "Kansas City, Mo.", "Las Vegas , Nev.", "Long Beach, Calif.", "Los Angeles", "Louisville-Jefferson County, Ky.2", "Memphis, Tenn.", "Mesa, Ariz.", "Miami, Fla.", "Milwaukee, Wis.", "Minneapolis, Minn.", "Nashville-Davidson, Tenn.1", "New Orleans", "New York", "Oakland, Calif.", "Oklahoma City, Okla.", "Omaha , Nebr.", "Philadelphia", "Phoenix", "Portland , Ore.", "Raleigh, N.C.", "Sacramento, Calif.", "San Antonio", "San Diego", "San Francisco , Calif.", "San Jose", "Seattle , Wash.", "Tucson, Ariz.", "Tulsa, Okla.", "Virginia Beach, Va.", "Washington, DC", "Wichita, Kans."]
        array_Cities.append(UnitedStates)
    }
}
