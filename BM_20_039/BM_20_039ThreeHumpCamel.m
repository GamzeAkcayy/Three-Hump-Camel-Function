rng(42); % farkli veriler olusmasin diye
egt=randi([-5,5],75,2);

[row_count, ~] = size(egt);

result_egt = zeros(row_count, 1);

for i = 1:row_count
    xx = egt(i, :);
    
    x1 = xx(1);
    x2 = xx(2);

    term1 = 2*x1^2;
    term2 = -1.05*x1^4;
    term3 = x1^6 / 6;
    term4 = x1*x2;
    term5 = x2^2;

    y = term1 + term2 + term3 + term4 + term5;
    
    result_egt(i) = y;
    
end
egt_yli = [egt result_egt];

test=randi([-5,5],50,2);
[row_countTest, ~] = size(test);
result_test = zeros(row_countTest, 1);
for i = 1:row_countTest
    xx = test(i, :);
    
    x1 = xx(1);
    x2 = xx(2);

    term1 = 2*x1^2;
    term2 = -1.05*x1^4;
    term3 = x1^6 / 6;
    term4 = x1*x2;
    term5 = x2^2;

    y = term1 + term2 + term3 + term4 + term5;
    
    result_test(i) = y;
    
end
test_yli = [test result_test];

% popuslayonu olustur
pop_uz=5;
krom_uz=12; % 2 giriş var, her bir girişin 2 ÜF var. ÜF gauss alında, çıkışta 1.dereceden lineer fonksyon
pop=randi([1,5],5,12);
for i=1:pop_uz
    % Oncul parametreleri atadık
    tempFis=readfis('BM_20_039MyFis.fis');
    tempFis.input(1).mf(1).params=pop(i,1:2); % X1 girisinin A1 üyelik fonksiyonu
    tempFis.input(1).mf(2).params=pop(i,3:4); %X1 girisinin A2 üyelik fonk
    tempFis.input(2).mf(1).params=pop(i,5:6); % X2 girisinin A1 üyelik fonk
    tempFis.input(2).mf(2).params=pop(i,7:8); %X2 girisinin A2 üyelik fonk
    %soncul (kuralların p katsayıları ve sabiti)
    tempFis.output(1).mf(1).params=pop(i,9); %1 kuralın p11, p12 (giris katsayıları), ve p13 (sabit)
    tempFis.output(1).mf(2).params=pop(i,10); % 2 kuralın p21, p22 (giris katsayıları), ve p23 (sabit)
    tempFis.output(1).mf(3).params=pop(i,11);  % 3 kuralın p31, p32 (giris katsayıları), ve p33 (sabit)
    tempFis.output(1).mf(4).params=pop(i,12); % 4 kuralın p41, p42 (giris katsayıları), ve p43 (sabit)
   %  i.inci kromozom için Uygunluk hesaplayalım
   % Oncelikle tahmin edilen y_sapka degeri hesaplanır 
   y_sapka=evalfis(egt,tempFis);
   %Sonrasında uygunluk olarak kullanacağım MSE (MeanSquare Error) degeri
   %hesaplanır.   
    mse_fitness(i,1)=mean((y-y_sapka).^2);
end

% Rulet çarkı için rastgele 5 sayı oluşturuldu
rng(42)
random_numbers = rand(5, 1);

disp('Üretilen Rastgele Sayılar:');
disp(random_numbers);

% Çaprazlama yapmak için 0-1 arasında 5 adet sayı seçildi.
rng(42)
random_caprazlama = rand(5, 1)';
disp(random_caprazlama);

% Beta değerleri için 0-1 arasında 5 adet sayı seçildi.
rng(42)
random_beta = rand(krom_uz, 1)';
disp(random_beta);

% En iyi kromozomun bulunması
best_solution = pop(find(mse_fitness == min(mse_fitness), 1), :);

disp(['En iyi kromozom: ' num2str(best_solution)]);
fuzzy(tempFis);  % gorsellestirmek icin (Ekranda görünen en son kromozomda olan ANFIS yapısı olur)
random_beta=rand(krom_uz,1)


