function PuntosExponencial = EncuentraExponencial(OD, t, plots, umbral)
% Esta función toma en cuenta todos los pozos que le pasen. Si solo hay mediciones en 60 pozos, no se recomienda pasar los 96.
% EncuentraExponencial(OD, t, plots)
% si plots=1 hace dibujos
% plots=0, no se detiene a hacer plots.
% va haciendo robustfits de 3 en 3 puntos del t y la OD. 
% cuando pasan el umbral find(pendientes>(max(pendientes)/2))
% umbral es un valor de 0 a 1 con la proporción de pozos en los que una medición específica del plato corresponde a la fase exponencial de >umbral pozos. Por ejemplo, si en la medición 2 del día 1 solo hay 5 pozos en fase exponencial y 91 no, entonces solo tomará esa medición si umbral<= 5/96

if nargin < 4
    umbral=0.5;
end

if plots
    figure(1)
    clf
    plot(t,OD,'-k')
    hold on
end

for w=1:size(OD,2)-3
   clear pendientes;
    
  for i=1:size(OD,1)-3
        [m]=robustfit(t(i:i+2), OD(i:i+2,w));
        pendientes(i)=m(2);
        if plots
            plot([t(i) t(i+2)], [t(i)*m(2)+m(1) m(2)*t(i+2)+m(1)],'-r')
            hold on
        end

  end
        Pexponencial=find(pendientes>(max(pendientes)*.4));%Límite de las pendientes que considera fase exponencial

        PuntosExponencialTemp(w,1:length(Pexponencial))=Pexponencial+1;
end
PuntosExponencialTemp(PuntosExponencialTemp==0) = NaN;
[uv,~,idx] = unique(PuntosExponencialTemp);
n = accumarray(idx(:),1);
minimovalidas=floor(max(n)*umbral);% es la fraccion de pozos que esperas que tengan curvas de crecimiento similares
PuntosExponencial= uv(n>minimovalidas)'; # Aquí 

        if plots
            plot(t(PuntosExponencial), OD(PuntosExponencial,:),'ob')
        end

end
