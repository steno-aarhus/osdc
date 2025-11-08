# Rationale

This document explains the rationale behind the development of this
algorithm. Many of these text were taken from Anders Aasted Isaksen’s
[PhD Thesis](https://aastedet.github.io/dissertation/) as well as the
validation paper ([1](#ref-Isaksen2023)). This document is a shorter and
more concise version of those documents. We cover the:

- Current state of how diabetes is identified in Danish healthcare
  registers.
- Challenges faced by researchers in this area, such as the limited
  transparency in how diabetes is exactly classified in these sources
  and how applying or using these approaches isn’t very easy.
- How this algorithm and package contributes to discussions in this
  space about how diabetes in classified in Danish register research and
  how it is implemented.

## Identifying type 1 and 2 diabetes cases in Danish healthcare registers

### Danish register data infrastructure

Many individual-level data (e.g. civil registration, public healthcare
contacts, and drug prescriptions) are automatically collected on all
residents in Denmark and stored in nationwide Danish registers by
[Statistics Denmark](https://www.dst.dk/da/) and the [Danish Health Data
Authority](https://sundhedsdatastyrelsen.dk/da). These agencies are
legally allowed to give access to the register data for research
purposes, which provides (authorized) researchers a set of common,
extensive data sources to use for studies. Any researcher associated
with an approved Danish research institute (mainly Danish universities)
can apply for access, but fees and conditions apply.

Register data is generally accessed and processed by approved
researchers on remote servers operated by Statistics Denmark and the
Danish Health Data Authority. The same raw data used by all researchers,
coupled with a common virtual working environment, has the potential to
enable reproducible research. This means that any data processing
workflow could be transferable and reusable between research projects if
the underlying code is designed with reproducibility in mind and the
code is shared (“open-sourced”) ([2](#ref-Marszalek2016)). While
reproducibility in research relates to transparent reporting of methods
to enable others to reproduce analyses and experiments, this also
applies to a diabetes classification program, which - if reproducible -
could be reused by any researcher with access to the necessary register
data to dynamically identify a study population of individuals with
diabetes for their research needs ([3](#ref-Dima2017)).

### Current Danish register-based diabetes classifiers

In Denmark, the National Diabetes Register, established in 2006, was the
first resource readily available to researchers to use for identifying
diabetes cases through register data ([4](#ref-Carstensen2011)) .
However, it was discontinued in 2012.

The next resource is the [Register of Selected Chronic
Diseases](https://www.esundhed.dk/Dokumentation/DocumentationExtended?id=29)
(RSCD), which was launched in 2014. It is currently the only publicly
available resource to identify diabetes cases through Danish register
data (by application to the Danish Health Data Authority).

## Challenges in current classifiers

General-purpose registers and other administrative databases often
provide the basis of diabetes epidemiology, but they rarely contain
validated diabetes-specific data, which may introduce bias in studies
using this data. It is important to have an accurate tool to identify
individuals with diabetes in the registers, as findings may differ with
various diabetes definitions
([5](#ref-Nielsen2014),[6](#ref-Rawshani2014)). Considerable efforts
have been made towards establishing such a tool for diabetes research in
several countries, including Denmark
([7](#ref-Bak2021)–[9](#ref-Cooper2013)).

In a general population, classification algorithms (classifiers) need to
not only identify type 1 diabetes as well as type 2 diabetes, but also
account for events that might lead to inclusion of non-cases, such as
the use of glucose-lowering drugs in the treatment of other conditions.
Currently, no type-specific diabetes classifier has been validated in a
general population, which leaves register-based studies in this area
vulnerable to biases.

In Denmark, a limitation (or flaw) of the RSCD is that it has not been
publicly validated and the source code behind the algorithm has not been
made publicly available. Notably, the algorithm lacks inclusion based on
elevated HbA1c levels ([10](#ref-DHDA2016)). Likewise, the National
Diabetes Register, since discontinued in 2012, had a validation study
question its validity and called for future registers to adopt inclusion
based on elevated HbA1c levels ([11](#ref-Green2014)).

Since the launch of the RSCD, nationwide laboratory data on HbA1c
testing has become available in the Danish register ecosystem
([12](#ref-DHDA2018)), but this data is yet to be incorporated into
available diabetes classifiers.

## Diabetes classification algorithms

The currently available register-based diabetes classifiers have yet to
incorporate the emerging register data on routine HbA1c testing. Wishing
to take advantage of this data, we developed the Open Source Diabetes
Classifier (OSDC). Detailed discussion of the advantages and
disadvantages of it’s design is found in Anders Aasted Isaksen’s thesis,
in the chapter on [discussing the
methods](https://aastedet.github.io/dissertation/5-discussion-methods.html).

We aimed on developing this algorithm to:

1.  Stimulate discussion within Denmark on the openness and ease of use
    of existing classifiers or diabetes registers, and on the need for
    an official process for updating or contributing to existing data
    sources on diabetes status. This algorithm and package may end up
    not being used by official institutions, but it can serve as a
    starting point on how to improve the current state of diabetes
    classification in Denmark or as an inspiration for how they might be
    designed.
2.  Provide an open-source, code-based algorithm as an R package to
    classify type 1 and type 2 diabetes based on data from Danish
    registers. We implemented it as an R package so that researchers can
    easily build their own database of individuals with diabetes more
    quickly than waiting for an official source to be implemented.

## References

1\.

Isaksen AA, Sandbæk A, Bjerg L. [Validation of register-based diabetes
classifiers in danish data](https://doi.org/10.2147/clep.s407019).
Clinical Epidemiology. 2023 May;Volume 15:569–81.

2\.

Marszalek RT, Flintoft L. [Being open: Our policy on source
code](https://doi.org/10.1186/s13059-016-1040-y). Genome Biology.
2016;17(1):172.

3\.

Dima AL, Dediu D. [Computation of adherence to medication and
visualization of medication histories in r with AdhereR: Towards
transparent and reproducible use of electronic healthcare
data](https://doi.org/10.1371/journal.pone.0174426). PLoS One.
2017;12(4):e0174426.

4\.

Carstensen B, Kristensen JK, Marcussen MM, Borch-Johnsen K. [The
national diabetes register](https://doi.org/10.1177/1403494811404278).
Scand J Public Health. 2011;39(7 Suppl):58–61.

5\.

Nielsen AA, Christensen H, Lund ED, Christensen C, Brandslund I, Green
A. Diabetes mortality differs between registers due to various disease
definitions. Dan Med J. 2014;61(5):A4840.

6\.

Rawshani A, Landin-Olsson M, Svensson AM, Nyström L, Arnqvist HJ,
Bolinder J, et al. [The incidence of diabetes among 0-34 year olds in
sweden: New data and better
methods](https://doi.org/10.1007/s00125-014-3225-9). Diabetologia.
2014;57(7):1375–81.

7\.

Bak JCG, Serné EH, Kramer MHH, Nieuwdorp M, Verheugt CL. [National
diabetes registries: Do they make a
difference?](https://doi.org/10.1007/s00592-020-01576-8) Acta
Diabetologica. 2021;58(3):267–78.

8\.

Hallgren Elfgren I-M, Grodzinsky E, Törnvall E. The swedish national
diabetes register in clinical practice and evaluation in primary health
care. Primary Health Care Research &amp; Development \[Internet\].
2016;17(6):549–58. Available from:
<https://www.cambridge.org/core/article/swedish-national-diabetes-register-in-clinical-practice-and-evaluation-in-primary-health-care/F3A9B74FED1E7B36147FF63382939B9A>

9\.

Cooper JG, Thue G, Claudi T, Løvaas K, Carlsen S, Sandberg S. The
norwegian diabetes register for adults – an overview of the first years.
Norsk Epidemiologi \[Internet\]. 2013;23(1). Available from:
<https://www.ntnu.no/ojs/index.php/norepid/article/view/1599>

10\.

Danish Health Data Authority. Algoritmer for udvalgte kroniske sygdomme
og svære psykiske lidelser \[English: Algorithms for selected chronic
diseases and serious mental illnesses\] \[Internet\]. 2016. Available
from:
<https://www.esundhed.dk/-/media/Files/Publikationer/Emner/Operationer-og-diagnoser/Udvalgte-kroniske-sygdomme-svaere-psykiske-lidelser/Algoritmer-for-Udvalgte-Kroniske-Sygdomme-og-svre-psykiske-lidelser.ashx>

11\.

Green A, Sortsø C, Jensen PB, Emneus M. Validation of the danish
national diabetes register. Clinical epidemiology \[Internet\].
2014;7:5–15. Available from:
[https://www.ncbi.nlm.nih.gov/pubmed/25565889
https://www.ncbi.nlm.nih.gov/pmc/PMC4274151/](https://www.ncbi.nlm.nih.gov/pubmed/25565889%0Ahttps://www.ncbi.nlm.nih.gov/pmc/PMC4274151/)

12\.

Danish Health Data Authority. Dokumentation af Laboratoriedatabasens
Forskertabel – Version 1.3 \[English: Documentation on Register of
Laboratory Results for Research - version 1.3\] \[Internet\]. 2018.
Available from:
<https://sundhedsdatastyrelsen.dk/-/media/sds/filer/registre-og-services/nationale-sundhedsregistre/doedsaarsager-og-biologisk-materiale/laboratoriedatabasen/dokumentation-af-labdatabasens-forskertabel.pdf>
