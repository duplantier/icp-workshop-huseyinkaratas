/*
  * Verileri neyin içinde tutuyoruz?
  * Tree yapısını kullanan bir uygulama yapacağız
  * Bir id ile değerimizi hash'liyor ve tree yapısında tutuyor.
  * Bu yapının içinde çok hızlı arama ve yeniden yapılandırma yapılabiliyor
  * var değiştirilebiliyor. let değiştirilemiyor.
  
  --UYGULAMA--
  * Super Hero kodu.
  * Super kahramanların özellikerlini tutacağız
  * Basic API fonksiyonları olacak - CRUD
*/

// Nat32, Tree yapısı için gerekli.
// Bunun ile şifreleme yapabiliyoruz çünkü.
import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie"; // Tree yapısının high-level kullanımı.
import Option "mo:base/Option"; // Kıyaslama küütphanesi. !=, == ile yetinemediğimiz durumlarda kullanmamız gerekiyor. `isSome()` var mı yok mu gibi şeyler var.
import List "mo:base/List"; // Metin listesi
import Text "mo:base/Text"; 
import Result "mo:base/Result"; 

actor {
  // `struct` kullanırız genelde. Veri tipi definition'ı.
  // Burada `type` kullanıyoruz.
  // Değişken tipi oluşturuyoruz. Kendi type'ımız. Obje hâlinde.
  // List kütüphanesi içinde bir sürü method var. Oluşturmak için `List.List` yapıyoruz en başta. Ya da aynı mantık `Map.Map`te de var. Listenin tipini <> içine giriyorsun. `<Text>` gibi.
  // Tree için Nat32 tipini kullanıyoruz.

  public type SuperHeroId = Nat32; // Kendi type'ımızı oluşturduk.

  public type SuperHero = {
    name: Text;
    powers: List.List<Text>; 
  };

  // Değişkeni oluşturalım
  // `private` yap ki diğer actor'ler erişemesin.
  // 0'dan başlıcaz. Birçok yerde bunu artıracağız.
  private stable var next: SuperHeroId = 0; 

  // Tüm süper kahramanları tutacak tree yapısını oluşturacağız.
  // SuperHero verimizi, superHeroId ile şifreleyip içinde tutacağız. superheroes tree'sinin içinde barınacak.
  private stable var superheroes: Trie.Trie<SuperHeroId, SuperHero> = Trie.empty(); 

  // İçine SuperHero olacak.
  // Geriye, kaydettiğimiz süper kahramanın id'sini döndürecek
  public func create(heroObj: SuperHero): async SuperHeroId{
    let superHeroId = next; 
    next += 1;

    // Trie yapısına bir şey kaydedeceğiz. Yeniden yapılandıracağız.
    // İçine bir şey kaydediyorsak `.0` olacak.
    // Bir şey kaydediyorsan/güncelliyorsan `.0` koyman lazım
    // Aşağıdaki şey bildiğin yeniden yapılandırıp güncelleme/kaydetme yapma işlemi.
    superheroes := Trie.replace(
      superheroes, // Yeniden yapılandıracağın Trie 
      key(superHeroId), // Gerekli
      Nat32.equal, // Gerekli
      ?heroObj // Boş gelip gelmediğini kontrol etmek için başına `?` koyuyoruz.
    ).0;
    
    superHeroId;
  };



  // id'yi alacağız, superhero'yu bulacağız.
  // Update edeceğimiz değeri alacağız
  // update edildi mi edilmedi mi, true false döndrecek
  public func update(id: SuperHeroId, updateValue: SuperHero): async Bool{
    let result = Trie.find(
      superheroes, // Hangi Trie yapısı içinde arayacaksın?
      key(id), // key fonksiyona git
      Nat32.equal
    ); // Exist ise direkt SuperHero objesini döndürüyor. Yoksa null döndürüyor.
    let isExist = Option.isSome(result);
    if(isExist){
      superheroes := Trie.replace(
        superheroes,
        key(id),
        Nat32.equal,
        ?updateValue,
      ).0; // Güncelleme yaptığın için `.0`
      // Tree yapısından ilk değerin dönmesini istediğimiz için `.0` yazıyoruz.
    };
    isExist
  };

  public func getHero(id:SuperHeroId) : async ?SuperHero{
    // Gelen id'ye sahip SuperHero var ise Trie'mizde, onu döndür.
    // Gelen id'de bir super hero olmayabilir. O yüzden return type'ın başına `?` koyman lazım.
     let result = Trie.find(
      superheroes, // Hangi Trie yapısı içinde arayacaksın?
      key(id), // key fonksiyona git
      Nat32.equal
    ); // Exist ise direkt SuperHero objesini döndürüyor. Yoksa null döndürüyor.
    result // Yoksa null gelecek
  };


    // Şifreleme fonksiyonumuz
  // SuperHeroId'yi alacak, hash'leme yapacak, şifreli halini döndürecek.
  private func key(x: SuperHeroId): Trie.Key<SuperHeroId>{
    { hash = x;  key = x; }
  };
}
