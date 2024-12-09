actor {
  // Değişken oluştur- var/let
  // let değiştirilebilir
  // var değiştirilemez
  // Değerin sıfırlanmaması, hafızada tutulması için `stable` yazacaksın.
  // Tip belirt. Type defnition.
  // 0-... doğal sayılar
  // Nat: Natural numbers. Float veya negatifler yok.
  stable var counter : Nat = 0;

  // Public: Herkes erişebilir
  // Private: Yalnızca bu actor erişebilir
  // Getter fonksiyon
  // Geriye hangi type döndüreceğini söylüyorsun
  // Fonksiyonların %99.9'una `async` koyman lazım
  // Geriye doğal sayı döndürmek istiyoruz: `Nat`
  // Return yazmadıkça hata verir.
  // Eğer bir fonksiyon değer döndürüyorsa `return` yazmak zorunda değilsin.
  // Son satırda ne yazıyorsa onu otomatik olarak döndürüyor Motoko.
  // Ama bu yazan değişkenin type'ı tanımlanan return type'ı ile uyuşmalı.
  // `public query func ...` olarak da tanımlayabilirsin getter fonksiyonları.
  public func getCount(): async Nat {
    counter;
  };

  public func increment(): async Nat {
    counter += 1; // işlemi yap
    counter; // değişkenin son halini döndür
  };

  public func decrement(): async Nat {
    if (counter != 0){
    counter -= 1; // işlemi yap
    };
    counter; // değişkenin son halini döndür
  };

  public func reset(): async Nat{
    counter := 0; // := Değer atama olayı. Tip belirtmediğin için := kalıyor. Motoko'ya özel bir şey.
    counter;
  };

  // Nat32, Nat64 gibi şeyler de var.
  public func addValue(value: Nat): async Nat{
      counter += value;
      counter;
  };
}
