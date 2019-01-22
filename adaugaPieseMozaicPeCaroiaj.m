function imgMozaic = adaugaPieseMozaicPeCaroiaj(params)
%tratati si cazul in care imaginea de referinta este gri (are numai un canal)

imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
[H,W,C,N] = size(params.pieseMozaic);
[h,w,c] = size(params.imgReferintaRedimensionata);

switch(params.criteriu)
    case 'aleator'
        %pune o piese aleatoare in mozaic, nu tine cont de nimic
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
                %alege un indice aleator din cele N
                indice = randi(N);    
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indice);
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        
    case 'distantaCuloareMedie'
        nrPieseAdaugate = 0;
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        %completati codul Matlab
		
        if c == 1
            for i = 1:size(params.pieseMozaic,4)
                pozeAlbNegru(:, :, i) = rgb2gray(params.pieseMozaic(:, :, :, i));
            end
        end
		
        for i = 1: size(params.pieseMozaic,4)
            if c == 3 %am 3 canale adica am RGB adica am poza color
                vmR = mean(mean(params.pieseMozaic(:,:,1,i)));
                vmG = mean(mean(params.pieseMozaic(:,:,2,i)));
                vmB = mean(mean(params.pieseMozaic(:,:,3,i)));

                CuloareMediePiese(i,:) = [vmR vmG,vmB];
            else %aici fac separat pt poze alb negru
                vm = mean(mean(pozeAlbNegru(:, :, i)));
                CuloareMediePN(i) = vm; % vector 
            end
        end
%             params.imgReferintaRedimensionata
         for i =1:size(params.pieseMozaic(:,:,:,1),1):size(params.imgReferintaRedimensionata,1)
            for j=1:size(params.pieseMozaic(:,:,:,1),2):size(params.imgReferintaRedimensionata,2)
               % extrag ferestre din imgReferintaRedimensionata
               fereastra = params.imgReferintaRedimensionata(i:i+size(params.pieseMozaic(:,:,:,1),1)-1, j:j+size(params.pieseMozaic(:,:,:,1),2)-1,:);
			   if c == 3 %la fel, fac pt poze color
				   fmR = mean(mean(fereastra(:,:,1))); 
				   fmG = mean(mean(fereastra(:,:,2)));
				   fmB = mean(mean(fereastra(:,:,3)));
               
                   % Calculez dist euclidiana
                   dist = sqrt(sum( ((CuloareMediePiese-repmat([fmR, fmG, fmB],[size(CuloareMediePiese,1),1])).^2 ) ,2));
                   % Aleg cea mai mica valoare din dist
                   [~, locatii] = min(dist);                           

                    imgMozaic(i:i+size(params.pieseMozaic(:,:,:,1),1)-1, j:j+size(params.pieseMozaic(:,:,:,1),2)-1,:) = params.pieseMozaic(:,:,:,locatii(1));
				else % acelasi lucru pt poze alb negru
					br = mean(mean(fereastra(:,:,1))); %fac media pe alb negru
                    deN = sqrt(sum( ((CuloareMediePN(:)-repmat(br,[N,1])).^2 ) ,2)); %fac distanta euclidiana
                    [~, locatii] = min(deN); %fac vectorul de distante minime
                    imgMozaic(i:i+H-1, j:j+W-1,:) = pozeAlbNegru(:,:,locatii(1)); %inclocuiesc blocul din imaginea rezultat cu imaginea cu distanta minima
				end
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        
    otherwise
        printf('EROARE, optiune necunoscuta \n');
    
end