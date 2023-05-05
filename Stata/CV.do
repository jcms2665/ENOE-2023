
*--------------------------------------------------------------------------------
* Tema:       Regresion logistica
* Autor:      Julio Cesar <jcms2665@gmail.com>
* Fecha:      09-02-2023
* Datos:      ENOEN_SDEMT422
* Liga:       https://www.inegi.org.mx/programas/enoe/15ymas/#Microdatos
*--------------------------------------------------------------------------------            

use "ENOEN_SDEMT422.dta", replace

* Filtro 1: encuestas completas
gen f1=((c_res==1 | c_res==3) & r_def==0 & (eda>=15 & eda<=98))

* Filtro 2, definir subpoblación de estudio: ocupados
gen f2=(f1==1 & clase2==1)


* El estimador a evaluar es: ocupados que vivían en otro país

* Muestreo complejo: estratificado y por conglomerados
svyset, clear
svyset upm [pw=fac_tri], strata(est_d_tri) vce(linearized) single(sca)
svy, subpop(f2): tab cs_nr_ori, format(%11.3g) count se cv ci level(90)


* Muestreo aleatorio

tabulate cs_nr_ori if f2==1 [iw=fac_tri], generate(p1)
summarize p13
display "CV: " (r(sd)/r(mean))

svyset, clear
svyset upm [pw=fac_tri], strata(est_d_tri) vce(linearized) single(sca)

svy, subpop(f2): regress hrsocup i.sex i.cs_p13_1 eda


