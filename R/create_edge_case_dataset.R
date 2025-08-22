# 0. Pseudo-pnr dictionary (to-do: move to website documentation) -----------------------------------------------------------

# Edge cases have pseudo-pnr values to support easier debugging

# Consisting of:

# a) Index number

# b) Expected diabetes classification

# c) Abbreviations of classification criteria and their expected evaluation

# F suffix indicates a criterion not fulfilled
# T suffix indicates a criterion fulfilled.

# Classification criteria dictionary (cases 1 - 11):

# oip: only_insulin_purchases
# any_t1d: any_t1d_primary_diagnoses
# endo: Has any type-specific diagnoses from endocrine dept.
# med: Has any type-specific diagnoses from (non-endocrine) medical dept.
# maj_t1d: majority_t1d_diagnoses
# i180: insulin_purchases_within_180_days
# itwo3: insulin_is_two_thirds_of_gld_doses

# Inclusion criteria dictionary (cases 12 - 16):



# Censoring criteria dictionary (cases 17 - 21):

# 1. bef: Demographics table -------------------------------------------------------------------------

bef_tbl <- tibble::tribble(
  ~pnr,                               ~koen, ~foed_dato,
  "01_t1d_oipT_anyt1dT",                   1, "19800101",
  "02_t2d_oipT_anyt1dF",                   2, "19810203",
  "03_t2d_oipF_anyt1dF",                   1, "19750510",
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", 1, "19901115",
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F", 2, "19910101",
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T", 1, "19880404",
  "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", 2, "19790606",
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  1, "19920808",
  "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",  2, "19930909",
  "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",  1, "19850707",
  "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  2, "19861010",
  "12_nodm_gldF_diagF_hba1cF_podF",         1, "19800101",
  "13_t2d_gldF_diagF_hba1cF_podT",          1, "19810101",
  "14_t2d_gldF_diagF_hba1cT_podF",          2, "19820101",
  "15_t2d_gldF_diagT_hba1cF_podF",          1, "19830101",
  "16_t2d_gldT_diagF_hba1cF_podF",          2, "19840101",
  "17_nodm_glp1a_dapa_empa",                1, "19700101",
  "18_t2d_male_pcosF",                       1, "20000101",
  "19_nodm_female_u40_pcosT",               2, "20000101",
  "20_nodm_female_o40_pcosT",               2, "19750101",
  "21_nodm_female_pregnancyT",              2, "19950101"
)

# 2. lmdb: Drug purchases table -------------------------------------------------------------------------

lmdb_tbl <- tibble::tribble(
  ~pnr,                                ~volume, ~eksd,     ~atc,      ~apk, ~indo,
  "01_t1d_oipT_anyt1dT",                      10, "20200110", "A10AB01",    5, "1234567",
  "01_t1d_oipT_anyt1dT",                      10, "20200410", "A10AE01",    5, "1234568",
  "02_t2d_oipT_anyt1dF",                      10, "20210220", "A10AB01",    5, "2345678",
  "02_t2d_oipT_anyt1dF",                      10, "20210520", "A10AE01",    5, "2345679",
  "03_t2d_oipF_anyt1dF",                      10, "20190101", "A10BA02",    3, "3456789",
  "03_t2d_oipF_anyt1dF",                      10, "20190301", "A10AB01",    3, "3456780",
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",    10, "20220101", "A10BA02",    2, "4567890",
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",    25, "20220301", "A10AB01",    8, "4567891",
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F",    10, "20220101", "A10BA02",    2, "5678901",
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F",    10, "20220301", "A10AB01",    8, "5678902",
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T",    10, "20220101", "A10BA02",    2, "6789012",
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T",    25, "20220901", "A10AB01",    8, "6789013",
  "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T",    10, "20220101", "A10BA02",    2, "7890123",
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",     10, "20230101", "A10BA02",    2, "8901234",
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",     25, "20230301", "A10AB01",    8, "8901235",
  "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",     10, "20230101", "A10BA02",    2, "9012345",
  "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",     10, "20230101", "A10BA02",    2, "1112233",
  "16_t2d_gldT_diagF_hba1cF_podF",           10, "20230101", "A10BA02",    5, "1600001",
  "16_t2d_gldT_diagF_hba1cF_podF",           10, "20230401", "A10BA02",    5, "1600002",
  "17_nodm_glp1a_dapa_empa",                10, "20230101", "A10BJ01",    5, "1700001",
  "17_nodm_glp1a_dapa_empa",                10, "20230401", "A10BK01",    5, "1700002",
  "18_t2d_male_pcosF",                      10, "20230101", "A10BA02",    5, "1800001",
  "18_t2d_male_pcosF",                      10, "20230401", "A10BA02",    5, "1800002",
  "19_nodm_female_u40_pcosT",               10, "20230101", "A10BA02",    5, "1900001",
  "19_nodm_female_u40_pcosT",               10, "20230401", "A10BA02",    5, "1900002",
  "20_nodm_female_o40_pcosT",               10, "20230101", "A10BA02",    5, "0000092",
  "20_nodm_female_o40_pcosT",               10, "20230401", "A10BA02",    5, "0000276",
  "20_nodm_female_o40_pcosT",               10, "20230501", "A10BA02",    5, "0000781",
  "21_nodm_female_pregnancyT",              10, "20230901", "A10BA02",    5, "2100001"
)

# 3. lpr_adm: Hospital admissions (LPR2) -------------------------------------------------------------------------

lpr_adm_tbl <- tibble::tribble(
  ~pnr,                                ~c_spec, ~recnum,      ~d_inddto,
  "01_t1d_oipT_anyt1dT",                   "08", "pnr01_rec01", "20210515",
  "02_t2d_oipT_anyt1dF",                   "08", "pnr02_rec01", "20220616",
  "03_t2d_oipF_anyt1dF",                   "35", "pnr03_rec01", "20200717",
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", "08", "pnr04_rec01", "20230120",
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F", "08", "pnr05_rec01", "20230221",
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T", "08", "pnr06_rec01", "20230322",
  "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", "08", "pnr07_rec01", "20230423",
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  "01", "pnr08_rec01", "20240120",
  "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",  "01", "pnr09_rec01", "20240221",
  "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",  "01", "pnr10_rec01", "20240322",
  "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "01", "pnr11_rec01", "20240423",
  "15_t2d_gldF_diagT_hba1cF_podF",          "08", "pnr15_rec01", "20230101"
)

# 4. lpr_diag: Hospital diagnoses (LPR2) -------------------------------------------------------------------------

lpr_diag_tbl <- tibble::tribble(
  ~recnum,       ~c_diag, ~c_diagtype,
  "pnr01_rec01", "250",    "A",
  "pnr02_rec01", "250",    "B",
  "pnr03_rec01", "250",    "A",
  "pnr04_rec01", "250",    "A",
  "pnr04_rec01", "250",    "A",
  "pnr04_rec01", "250",    "B",
  "pnr05_rec01", "250",    "A",
  "pnr06_rec01", "250",    "A",
  "pnr07_rec01", "250",    "B",
  "pnr08_rec01", "250",    "A",
  "pnr09_rec01", "250",    "A",
  "pnr10_rec01", "250",    "A",
  "pnr11_rec01", "250",    "B",
  "pnr15_rec01", "250",    "A",
  "pnr15_rec01", "250",    "A"
)

# 5. kontakter: Hospital contacts (LPR3) -------------------------------------------------------------------------

kontakter_tbl <- tibble::tribble(
  ~cpr,                                ~dw_ek_kontakt, ~hovedspeciale_ans,        ~dato_start,
  "01_t1d_oipT_anyt1dT",                 "pnr01_dw01", "medicinsk endokrinologi", "20210515",
  "02_t2d_oipT_anyt1dF",                 "pnr02_dw01", "medicinsk endokrinologi", "20220616",
  "03_t2d_oipF_anyt1dF",                 "pnr03_dw01", "kirurgi",                 "20200717",
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", "pnr04_dw01", "medicinsk endokrinologi", "20230120",
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F", "pnr05_dw01", "medicinsk endokrinologi", "20230221",
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T", "pnr06_dw01", "medicinsk endokrinologi", "20230322",
  "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", "pnr07_dw01", "medicinsk endokrinologi", "20230423",
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  "pnr08_dw01", "kardiologi",              "20240120",
  "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",  "pnr09_dw01", "kardiologi",              "20240221",
  "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",  "pnr10_dw01", "kardiologi",              "20240322",
  "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "pnr11_dw01", "kardiologi",              "20240423",
  "15_t2d_gldF_diagT_hba1cF_podF",       "pnr15_dw01", "almen medicin",           "20230101",
  "21_nodm_female_pregnancyT",           "pnr21_dw01", "gynækologi og obstetrik", "20240101"
)

# 6. diagnoser: Hospital diagnoses (LPR3) -------------------------------------------------------------------------

diagnoser_tbl <- tibble::tribble(
  ~dw_ek_kontakt, ~diagnosekode, ~diagnosetype, ~senere_afkraeftet,
  "pnr01_dw01",   "DE10",        "A",           "Nej",
  "pnr02_dw01",   "DE10",        "B",           "Nej",
  "pnr03_dw01",   "DE11",        "A",           "Nej",
  "pnr04_dw01",   "DE10",        "A",           "Nej",
  "pnr04_dw01",   "DE10",        "A",           "Nej",
  "pnr04_dw01",   "DE11",        "B",           "Nej",
  "pnr05_dw01",   "DE10",        "A",           "Nej",
  "pnr06_dw01",   "DE10",        "A",           "Nej",
  "pnr07_dw01",   "DE10",        "B",           "Nej",
  "pnr07_dw01",   "DE11",        "A",           "Nej",
  "pnr08_dw01",   "DE10",        "A",           "Nej",
  "pnr09_dw01",   "DE10",        "A",           "Nej",
  "pnr10_dw01",   "DE10",        "A",           "Nej",
  "pnr11_dw01",   "DE11",        "A",           "Nej",
  "pnr15_dw01",   "DE14",        "A",           "Nej",
  "pnr15_dw01",   "DE14",        "A",           "Nej",
  "pnr21_dw01",   "DO80",        "A",           "Nej"
)

# 7. sysi: Health services table -------------------------------------------------------------------------

sysi_tbl <- tibble::tribble(
  ~pnr,                                ~barnmak, ~speciale, ~honuge,
  "01_t1d_oipT_anyt1dT",                      0, "10022",    "9329",
  "02_t2d_oipT_anyt1dF",                      0, "88475",    "0442",
  "03_t2d_oipF_anyt1dF",                      0, "83575",    "9549",
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",      0, "86409",    "9603",
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F",      0, "42818",    "9215",
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T",      0, "67148",    "9924",
  "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T",      0, "62545",    "9727",
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",       0, "20866",    "9632",
  "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",       0, "27002",    "0213",
  "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",       0, "53825",    "9419",
  "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",       0, "12345",    "1234",
  "12_nodm_gldF_diagF_hba1cF_podF",          0, "10001",    "1001",
  "13_t2d_gldF_diagF_hba1cF_podT",           0, "10002",    "1002",
  "14_t2d_gldF_diagF_hba1cT_podF",           0, "10003",    "1003",
  "15_t2d_gldF_diagT_hba1cF_podF",           0, "10004",    "1004",
  "16_t2d_gldT_diagF_hba1cF_podF",           0, "10005",    "1005",
  "17_nodm_glp1a_dapa_empa",                 0, "10006",    "1006",
  "18_t2d_male_pcosF",                     0, "10007",    "1007",
  "19_nodm_female_u40_pcosT",              0, "10008",    "1008",
  "20_nodm_female_o40_pcosT",              0, "10009",    "1009",
  "21_nodm_female_pregnancyT",             0, "10010",    "1010"
)

# 8. sssy: Health services table-------------------------------------------------------------------------

sssy_tbl <- tibble::tribble(
  ~pnr,                                ~barnmak, ~speciale, ~honuge,
  "01_t1d_oipT_anyt1dT",                      0, "54100",    "0830",
  "02_t2d_oipT_anyt1dF",                      0, "88475",    "1942",
  "03_t2d_oipF_anyt1dF",                      0, "83575",    "1049",
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",      0, "86409",    "2421",
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F",      0, "42818",    "1103",
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T",      0, "67148",    "0714",
  "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T",      0, "62545",    "2221",
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",       0, "20866",    "1425",
  "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",       0, "27002",    "2237",
  "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",       0, "53825",    "1227",
  "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",       0, "12345",    "1234",
  "12_nodm_gldF_diagF_hba1cF_podF",          0, "20001",    "2001",
  "13_t2d_gldF_diagF_hba1cF_podT",           0, "54001",    "2002",
  "13_t2d_gldF_diagF_hba1cF_podT",           0, "54002",    "2003",
  "14_t2d_gldF_diagF_hba1cT_podF",           0, "20002",    "2004",
  "15_t2d_gldF_diagT_hba1cF_podF",           0, "20003",    "2005",
  "16_t2d_gldT_diagF_hba1cF_podF",           0, "20004",    "2006",
  "17_nodm_glp1a_dapa_empa",                 0, "20005",    "2007",
  "18_t2d_male_pcosF",                     0, "20006",    "2008",
  "19_nodm_female_u40_pcosT",              0, "20007",    "2009",
  "20_nodm_female_o40_pcosT",              0, "20008",    "2010",
  "21_nodm_female_pregnancyT",             0, "20009",    "2011"
)

# 9. lab_forsker: Lab results table -------------------------------------------------------------------------

lab_forsker_tbl <- tibble::tribble(
  ~patient_cpr,                        ~samplingdate, ~analysiscode, ~value,
  "01_t1d_oipT_anyt1dT",                 "20190101",    "NPU27300",    50,
  "02_t2d_oipT_anyt1dF",                 "20190101",    "NPU27300",    51,
  "03_t2d_oipF_anyt1dF",                 "20190101",    "NPU27300",    52,
  "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", "20190101",    "NPU27300",    53,
  "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F", "20190101",    "NPU27300",    54,
  "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T", "20190101",    "NPU27300",    55,
  "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", "20190101",    "NPU27300",    56,
  "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  "20190101",    "NPU27300",    57,
  "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",  "20190101",    "NPU27300",    58,
  "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",  "20190101",    "NPU27300",    59,
  "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "20190101",    "NPU27300",    60,
  "12_nodm_gldF_diagF_hba1cF_podF",      "20230101",    "NPU27300",    50,
  "14_t2d_gldF_diagF_hba1cT_podF",       "20230101",    "NPU27300",    55,
  "14_t2d_gldF_diagF_hba1cT_podF",       "20230401",    "NPU27300",    56,
  "21_nodm_female_pregnancyT",           "20230801",    "NPU27300",    55
)

# Combine all tibbles into a named list -------------------------------------------------------------------------

osdc_test_data <- list(
  bef = bef_tbl,
  lmdb = lmdb_tbl,
  lpr_adm = lpr_adm_tbl,
  lpr_diag = lpr_diag_tbl,
  kontakter = kontakter_tbl,
  diagnoser = diagnoser_tbl,
  sysi = sysi_tbl,
  sssy = sssy_tbl,
  lab_forsker = lab_forsker_tbl
)
