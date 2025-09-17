# Create test dataset of edge cases:

create_test_cases <- function() {
  # 1. bef: Demographics table -------------------------------------------------------------------------

  bef_tbl <- tibble::tribble(
    ~pnr,                               ~koen, ~foed_dato,
    "01_t1d_oipT_anyt1dT",                   1, "19800101",
    "02_t2d_oipT_anyt1dF",                   2, "19810203",
    "03_t2d_oipF_anyt1dF",                   1, "19750510",
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", 2, "19601115",
    "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F", 2, "19510101",
    "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T", 1, "19880404",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", 2, "19530606",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  1, "19920808",
    "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",  1, "19930909",
    "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",  1, "19850707",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  2, "19561010",
    "12_nodm_gldF_diagF_hba1cF_podF",         1, "19800101",
    "13_t2d_gldF_diagF_hba1cF_podT",          1, "19810101",
    "14_t2d_gldF_diagF_hba1cT_podF",          2, "19720101",
    "15_t2d_gldF_diagT_hba1cF_podF",          1, "19830101",
    "16_t2d_gldT_diagF_hba1cF_podF",          2, "19720101",
    "17_nodm_glp1a_dapa_empa",                1, "19700101",
    "18_t2d_male_pcosF",                       1, "20000101",
    "19_nodm_female_u40_pcosT",               2, "20000101",
    "20_nodm_female_o40_pcosT",               2, "19750101",
    "21_nodm_female_pregnancyT",              2, "19950101",
    "22_nodm_female_blank",                   2, "19960101",
    "23_t2d_gldT_1995_1999",                  1, "19500101"
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
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",    10, "19980101", "A10BA02",    8, "4567890",
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",    10, "20220101", "A10BA02",    2, "4567890",
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",    10, "20220301", "A10AB01",    8, "4567891",
    "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F",    10, "20220101", "A10BA02",    5, "5678901",
    "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F",    10, "20220301", "A10AB01",    5, "5678902",
    "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T",    10, "20220101", "A10BA02",    2, "6789012",
    "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T",    10, "20220901", "A10AB01",    8, "6789013",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T",    10, "20220101", "A10BA02",    2, "7890123",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T",    10, "20220201", "A10AE02",    8, "7890123",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",     10, "20230301", "A10BA02",    2, "8901234",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",     10, "20230101", "A10AB01",    8, "8901235",
    "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",     10, "20230101", "A10AE02",    5, "9012345",
    "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",     10, "20230101", "A10BA02",    5, "9012345",
    "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",    10, "20220101", "A10BA02",    2, "6789012",
    "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",    10, "20220901", "A10AB01",    8, "6789013",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",    10, "20220101", "A10BA02",    2, "7890123",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",    10, "20220201", "A10AE02",    8, "7890123",
    "12_nodm_gldF_diagF_hba1cF_podF",           10, "20210101", "A02BC02",    2, "7890123",
    "12_nodm_gldF_diagF_hba1cF_podF",           10, "20220201", "C10AA01",    8, "7890123",
    "16_t2d_gldT_diagF_hba1cF_podF",           10, "20130101", "A10BA02",    5, "1600001",
    "16_t2d_gldT_diagF_hba1cF_podF",           10, "20130401", "A10AB01",    5, "1600002",
    "17_nodm_glp1a_dapa_empa",                10, "20220101", "A10BJ01",    5, "1700002",
    "17_nodm_glp1a_dapa_empa",                10, "20220201", "A10BK01",    5, "1700001",
    "17_nodm_glp1a_dapa_empa",                10, "20220401", "A10BK03",    5, "1700002",
    "17_nodm_glp1a_dapa_empa",                10, "20230101", "A10BJ01",    5, "1700002",
    "17_nodm_glp1a_dapa_empa",                10, "20230201", "A10BK01",    5, "1700001",
    "17_nodm_glp1a_dapa_empa",                10, "20230401", "A10BK03",    5, "1700002",
    "18_t2d_male_pcosF",                      10, "20230101", "A10BA02",    5, "1800001",
    "18_t2d_male_pcosF",                      10, "20230401", "A10BA02",    5, "1800002",
    "19_nodm_female_u40_pcosT",               10, "20230101", "A10BA02",    5, "1900001",
    "19_nodm_female_u40_pcosT",               10, "20230401", "A10BA02",    5, "1900002",
    "20_nodm_female_o40_pcosT",               10, "20220101", "A10BA02",    5, "0000092",
    "20_nodm_female_o40_pcosT",               10, "20220401", "A10BA02",    5, "0000276",
    "20_nodm_female_o40_pcosT",               10, "20220501", "A10BA02",    5, "0000781",
    "20_nodm_female_o40_pcosT",               10, "20230101", "A10BA02",    5, "0000092",
    "20_nodm_female_o40_pcosT",               10, "20230401", "A10BA02",    5, "0000276",
    "20_nodm_female_o40_pcosT",               10, "20230501", "A10BA02",    5, "0000781",
    "21_nodm_female_pregnancyT",              10, "19980901", "A10AB01",    5, "2100001",
    "21_nodm_female_pregnancyT",              10, "19990102", "A10AB01",    5, "2100001",
    "21_nodm_female_pregnancyT",              10, "20230901", "A10AB01",    5, "2100001",
    "21_nodm_female_pregnancyT",              10, "20240102", "A10AB01",    5, "2100001",
    "23_t2d_gldT_1995_1999",                    10,      "19950615", "A10BA02",   1,    "2300001",
    "23_t2d_gldT_1995_1999",                    10,      "19950616", "A10BA02",   2,    "2300001",
    "23_t2d_gldT_1995_1999",                    10,      "19960615", "A10BA02",   3,    "2300002",
    "23_t2d_gldT_1995_1999",                    10,      "19960616", "A10BA02",   4,    "2300002",
    "23_t2d_gldT_1995_1999",                    10,      "19970615", "A10BA02",   1,    "2300003",
    "23_t2d_gldT_1995_1999",                    10,      "19970616", "A10BA02",   2,    "2300003",
    "23_t2d_gldT_1995_1999",                    10,      "19980615", "A10BA02",   3,    "2300003",
    "23_t2d_gldT_1995_1999",                    10,      "19980616", "A10BA02",   4,    "2300003",
  )

  # 3. lpr_adm: Hospital admissions (LPR2) -------------------------------------------------------------------------

  lpr_adm_tbl <- tibble::tribble(
    ~pnr,                                ~c_spec, ~recnum,      ~d_inddto,
    "01_t1d_oipT_anyt1dT",                   "08", "pnr01_rec01", "20110515",
    "02_t2d_oipT_anyt1dF",                   "08", "pnr02_rec01", "20220616",
    "03_t2d_oipF_anyt1dF",                   "34", "pnr03_rec01", "20200717",
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", "08", "pnr04_rec01", "19920120",
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", "08", "pnr04_rec02", "20230120",
    "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F", "08", "pnr05_rec01", "20230221",
    "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T", "08", "pnr06_rec01", "20230322",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", "08", "pnr07_rec01", "20220423",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", "02", "pnr07_rec02", "20230423",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  "01", "pnr08_rec01", "19920120",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  "08", "pnr08_rec02", "20240120",
    "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",  "01", "pnr09_rec01", "20240221",
    "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",  "01", "pnr10_rec01", "20240322",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "32", "pnr11_rec01", "19920423",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "02", "pnr11_rec02", "20000423",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "99", "pnr11_rec03", "20010423",
    "12_nodm_gldF_diagF_hba1cF_podF",         "01", "pnr12_rec01", "20220423",
    "14_t2d_gldF_diagF_hba1cT_podF",          "38", "pnr14_rec01", "19990101",
    "15_t2d_gldF_diagT_hba1cF_podF",          "08", "pnr15_rec01", "20100101",
    "16_t2d_gldT_diagF_hba1cF_podF",          "38", "pnr16_rec01", "19990101",
    "21_nodm_female_pregnancyT",              "38", "pnr21_rec01", "19990101",
  )

  # 4. lpr_diag: Hospital diagnoses (LPR2) -------------------------------------------------------------------------

  lpr_diag_tbl <- tibble::tribble(
    ~recnum,       ~c_diag, ~c_diagtype,
    "pnr01_rec01", "DE111",    "A",
    "pnr02_rec01", "DE110",    "A",
    "pnr03_rec01", "DE101",    "A",
    "pnr04_rec01", "24901",    "A",
    "pnr04_rec02", "DE105",    "A",
    "pnr04_rec02", "DE114",    "B",
    "pnr05_rec01", "250",      "A",
    "pnr06_rec01", "DE103",    "A",
    "pnr07_rec01", "DE115",    "A",
    "pnr07_rec01", "DE105",    "B",
    "pnr07_rec02", "DE106",    "A",
    "pnr07_rec02", "DE105",    "B",
    "pnr08_rec01", "25001",    "A",
    "pnr08_rec02", "DE115",    "B",
    "pnr08_rec02", "DE114",    "B",
    "pnr09_rec01", "250",    "A",
    "pnr10_rec01", "DE103",    "A",
    "pnr11_rec01", "24901",    "A",
    "pnr11_rec02", "DE115",    "A",
    "pnr11_rec02", "DE105",    "B",
    "pnr11_rec03", "DE105",    "A",
    "pnr11_rec03", "DE106",    "B",
    "pnr12_rec01", "DI211",    "A",
    "pnr12_rec01", "DI11",    "B",
    "pnr14_rec01", "DZ331",    "A",
    "pnr15_rec01", "DE110",    "A",
    "pnr15_rec01", "DI250",    "B",
    "pnr16_rec01", "DZ371",    "A",
    "pnr21_rec01", "DZ371",    "A"
  )

  # 5. kontakter: Hospital contacts (LPR3) -------------------------------------------------------------------------

  kontakter_tbl <- tibble::tribble(
    ~cpr,                                ~dw_ek_kontakt, ~hovedspeciale_ans,        ~dato_start,
    "01_t1d_oipT_anyt1dT",                    "pnr01_dw01", "medicinsk endokrinologi",  "20210515",
    "02_t2d_oipT_anyt1dF",                    "pnr02_dw01", "thoraxkirurgi",            "20220616",
    "03_t2d_oipF_anyt1dF",                    "pnr03_dw01", "kardiologi",               "20200717",
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T", "pnr04_dw01", "medicinsk endokrinologi",  "20230120",
    "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F", "pnr05_dw01", "medicinsk endokrinologi",  "20230221",
    "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T", "pnr06_dw01", "medicinsk endokrinologi",  "20230322",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", "pnr07_dw01", "medicinsk endokrinologi",  "20220423",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T", "pnr07_dw02", "geriatri",                 "20230423",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  "pnr08_dw01", "kardiologi",               "20230120",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",  "pnr08_dw02", "kardiologi",               "20240120",
    "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",  "pnr09_dw01", "kardiologi",               "20240221",
    "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",  "pnr10_dw01", "kardiologi",               "20240322",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "pnr11_dw01", "kardiologi",               "20230423",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "pnr11_dw02", "medicinsk endokrinologi",  "20240423",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",  "pnr11_dw03", "thoraxkirurgi",            "20240616",
    "12_nodm_gldF_diagF_hba1cF_podF",         "pnr12_dw01", "kardiologi",               "20210423",
    "14_t2d_gldF_diagF_hba1cT_podF",          "pnr14_dw01", "gynaekologi og obstetrik", "20240101",
    "15_t2d_gldF_diagT_hba1cF_podF",          "pnr15_dw01", "urologi",                  "20230101",
    "16_t2d_gldT_diagF_hba1cF_podF",          "pnr16_dw01", "gynaekologi og obstetrik", "20240101",
    "21_nodm_female_pregnancyT",              "pnr21_dw01", "gynaekologi og obstetrik", "20240101"
  )

  # 6. diagnoser: Hospital diagnoses (LPR3) -------------------------------------------------------------------------

  diagnoser_tbl <- tibble::tribble(
    ~dw_ek_kontakt, ~diagnosekode, ~diagnosetype, ~senere_afkraeftet,
    "pnr01_dw01",   "DE101",        "A",           "Nej",
    "pnr02_dw01",   "DE102",        "A",           "Nej",
    "pnr03_dw01",   "DE103",        "A",           "Nej",
    "pnr04_dw01",   "DE104",        "A",           "Nej",
    "pnr04_dw02",   "DE115",        "B",           "Nej",
    "pnr04_dw02",   "DE119",        "B",           "Nej",
    "pnr05_dw01",   "DE101",        "A",           "Nej",
    "pnr06_dw01",   "DE102",        "A",           "Nej",
    "pnr07_dw01",   "DE103",        "A",           "Nej",
    "pnr07_dw01",   "DE109",        "B",           "Nej",
    "pnr07_dw02",   "DE104",        "A",           "Nej",
    "pnr07_dw02",   "DE108",        "B",           "Nej",
    "pnr08_dw01",   "DE114",        "A",           "Nej",
    "pnr08_dw02",   "DE105",        "A",           "Nej",
    "pnr08_dw02",   "DE119",        "B",           "Nej",
    "pnr09_dw01",   "DE10",         "A",           "Nej",
    "pnr10_dw01",   "DE101",        "A",           "Nej",
    "pnr11_dw01",   "DE112",        "A",           "Nej",
    "pnr11_dw01",   "DE102",        "B",           "Nej",
    "pnr11_dw02",   "DE109",        "B",           "Nej",
    "pnr11_dw02",   "DI739",        "B",           "Nej",
    "pnr11_dw03",   "DE102",        "A",           "Nej",
    "pnr12_dw01",   "DI25",         "A",           "Nej",
    "pnr12_dw01",   "DE110",        "A",           "Ja",
    "pnr14_dw01",   "DO041",        "A",           "Nej",
    "pnr15_dw01",   "DI25",        "A",           "Nej",
    "pnr15_dw01",   "DE110",        "B",           "Nej",
    "pnr16_dw01",   "DO822",        "A",           "Nej",
    "pnr21_dw01",   "DO806",        "A",           "Nej"
  )

  # 7. sysi: Health services table -------------------------------------------------------------------------

  sysi_tbl <- tibble::tribble(
    ~pnr,                                ~barnmak, ~speciale, ~honuge,
    "01_t1d_oipT_anyt1dT",                      0, "54022",    "9329",
    "02_t2d_oipT_anyt1dF",                      0, "54475",    "0442",
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
    "12_nodm_gldF_diagF_hba1cF_podF",          1, "54002",    "1001",
    "12_nodm_gldF_diagF_hba1cF_podF",          0, "10001",    "1002",
    "12_nodm_gldF_diagF_hba1cF_podF",          1, "54002",    "1002",
    "13_t2d_gldF_diagF_hba1cF_podT",           0, "54002",    "0002",
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
    "02_t2d_oipT_anyt1dF",                      0, "54475",    "1942",
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
    "13_t2d_gldF_diagF_hba1cF_podT",           0, "54001",    "1002",
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
    "12_nodm_gldF_diagF_hba1cF_podF",      "20100101",    "NPU03835",    4.3,
    "12_nodm_gldF_diagF_hba1cF_podF",      "20110101",    "NPU03835",    4.5,
    "12_nodm_gldF_diagF_hba1cF_podF",      "20200101",    "NPU27300",    43,
    "12_nodm_gldF_diagF_hba1cF_podF",      "20210101",    "NPU27300",    45,
    "12_nodm_gldF_diagF_hba1cF_podF",      "20220101",    "NPU27300",    49,
    "12_nodm_gldF_diagF_hba1cF_podF",      "20220101",    "DNK35302",    90,
    "12_nodm_gldF_diagF_hba1cF_podF",      "20230101",    "DNK35302",    90,
    "14_t2d_gldF_diagF_hba1cT_podF",       "20100101",    "NPU03835",    6.9,
    "14_t2d_gldF_diagF_hba1cT_podF",       "20130401",    "NPU27300",    56,
    "21_nodm_female_pregnancyT",           "19980801",    "NPU27300",    55,
    "21_nodm_female_pregnancyT",           "19990201",    "NPU27300",    55,
    "21_nodm_female_pregnancyT",           "20230801",    "NPU27300",    55,
    "21_nodm_female_pregnancyT",           "20240201",    "NPU27300",    55
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

  return(osdc_test_data)
}

# Test pipeline on edge cases:

test_that("Classifying edge cases produces unexpected outcomes", {
  edge_case_data <- create_test_cases()

  actual <- classify_diabetes(
    kontakter = edge_case_data$kontakter,
    diagnoser = edge_case_data$diagnoser,
    lpr_diag = edge_case_data$lpr_diag,
    lpr_adm = edge_case_data$lpr_adm,
    sysi = edge_case_data$sysi,
    sssy = edge_case_data$sssy,
    lab_forsker = edge_case_data$lab_forsker,
    bef = edge_case_data$bef,
    lmdb = edge_case_data$lmdb
  )

  # TODO: input the expected output here:
  expected <- tibble::tribble(
    # Column headers
    ~pnr,                                     ~stable_inclusion_date, ~raw_inclusion_date, ~diabetes_type,
    "01_t1d_oipT_anyt1dT",                      "2020-04-10",           "2020-04-10",          "T1D",
    "02_t2d_oipT_anyt1dF",                      "2021-05-20",           "2021-05-20",          "T2D",
    "03_t2d_oipF_anyt1dF",                      "2019-03-01",           "2019-03-01",          "T2D",
    "04_t1d_oipF_endoT_majt1dT_i180T_itwo3T",    "1998-01-01",           "1998-01-01",          "T1D",
    "05_t2d_oipF_endoT_majt1dT_i180T_itwo3F",    "2022-03-01",           "2022-03-01",          "T2D",
    "06_t2d_oipF_endoT_majt1dT_i180F_itwo3T",    "2022-09-01",           "2022-09-01",          "T2D",
    "07_t2d_oipF_endoT_majt1dF_i180T_itwo3T",    "2022-02-01",           "2022-02-01",          "T2D",
    "08_t1d_oipF_medT_majt1dT_i180T_itwo3T",     "2023-01-01",           "2023-01-01",          "T1D",
    "09_t2d_oipF_medT_majt1dT_i180T_itwo3F",     "2023-01-01",           "2023-01-01",          "T2D",
    "10_t2d_oipF_medT_majt1dT_i180F_itwo3T",     "2022-09-01",           "2022-09-01",          "T2D",
    "11_t2d_oipF_medT_majt1dF_i180T_itwo3T",     "2000-04-23",           "2000-04-23",          "T2D",
    "13_t2d_gldF_diagF_hba1cF_podT",            "2000-01-10",           "2000-01-10",          "T2D",
    "14_t2d_gldF_diagF_hba1cT_podF",            "2013-04-01",           "2013-04-01",          "T2D",
    "15_t2d_gldF_diagT_hba1cF_podF",            "2023-01-01",           "2023-01-01",          "T2D",
    "16_t2d_gldT_diagF_hba1cF_podF",            "2013-04-01",           "2013-04-01",          "T2D",
    "18_t2d_male_pcosF",                        "2023-04-01",           "2023-04-01",          "T2D",
    "23_t2d_gldT_1995_1999",                    NA,                     "1995-06-16",          "T2D"

  )

  expect_equal(actual, expected)
})





# Create a larger synthetic dataset to test backends

register_data <- simulate_registers(
  c(
    "kontakter",
    "diagnoser",
    "lpr_diag",
    "lpr_adm",
    "sysi",
    "sssy",
    "lab_forsker",
    "bef",
    "lmdb"
  ),
  n = 10000
)

test_that("classifying works with DuckDB Database", {
  skip_on_cran()
  skip_if_not_installed("duckplyr")
  registers_as_ddb <- register_data |>
    purrr::map(duckplyr::as_duckdb_tibble)

  actual <- classify_diabetes(
    kontakter = registers_as_ddb$kontakter,
    diagnoser = registers_as_ddb$diagnoser,
    lpr_diag = registers_as_ddb$lpr_diag,
    lpr_adm = registers_as_ddb$lpr_adm,
    sysi = registers_as_ddb$sysi,
    sssy = registers_as_ddb$sssy,
    lab_forsker = registers_as_ddb$lab_forsker,
    bef = registers_as_ddb$bef,
    lmdb = registers_as_ddb$lmdb
  ) |>
    dplyr::compute()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )
  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "duckplyr_df")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})

test_that("classifying works for Arrow Tables (from Parquet)", {
  # TODO: Currently, Arrow fails bc it can't handle doing a comparison (<)
  # between two different types (date - foed_dato is a duration; years(40) is
  # a period) in the logic.
  # This issue happens in the `exclude_potential_pcos()` function.
  # I've also tried converting date, foed_dato, and 40 years to
  # numbers before the comparison, but it still fails bc arrow can't cast date32
  # to a double directly.
  skip()
  skip_on_cran()
  skip_if_not_installed("arrow")
  registers_as_arrow <- register_data |>
    purrr::map(arrow::as_arrow_table)

  actual <- classify_diabetes(
    kontakter = registers_as_arrow$kontakter,
    diagnoser = registers_as_arrow$diagnoser,
    lpr_diag = registers_as_arrow$lpr_diag,
    lpr_adm = registers_as_arrow$lpr_adm,
    sysi = registers_as_arrow$sysi,
    sssy = registers_as_arrow$sssy,
    lab_forsker = registers_as_arrow$lab_forsker,
    bef = registers_as_arrow$bef,
    lmdb = registers_as_arrow$lmdb
  ) |>
    dplyr::collect()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "Table")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})

test_that("classifying works for data.frame", {
  registers_as_df <- register_data |>
    purrr::map(as.data.frame)

  actual <- classify_diabetes(
    kontakter = registers_as_df$kontakter,
    diagnoser = registers_as_df$diagnoser,
    lpr_diag = registers_as_df$lpr_diag,
    lpr_adm = registers_as_df$lpr_adm,
    sysi = registers_as_df$sysi,
    sssy = registers_as_df$sssy,
    lab_forsker = registers_as_df$lab_forsker,
    bef = registers_as_df$bef,
    lmdb = registers_as_df$lmdb
  ) |>
    dplyr::collect()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "data.frame")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})

test_that("classifying works for data.table", {
  skip_on_cran()
  skip_if_not_installed("data.table")
  registers_as_dt <- register_data |>
    purrr::map(data.table::as.data.table)

  actual <- classify_diabetes(
    kontakter = registers_as_dt$kontakter,
    diagnoser = registers_as_dt$diagnoser,
    lpr_diag = registers_as_dt$lpr_diag,
    lpr_adm = registers_as_dt$lpr_adm,
    sysi = registers_as_dt$sysi,
    sssy = registers_as_dt$sssy,
    lab_forsker = registers_as_dt$lab_forsker,
    bef = registers_as_dt$bef,
    lmdb = registers_as_dt$lmdb
  ) |>
    dplyr::collect()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "data.frame")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})

test_that("casing of input variables doesn't matter", {
  # Testing this for data.frame input only here.
  registers_as_df <- register_data |>
    purrr::map(as.data.frame) |>
    # Convert column names to upper case.
    purrr::map(~ setNames(.x, toupper(names(.x))))

  actual <- classify_diabetes(
    kontakter = registers_as_df$kontakter,
    diagnoser = registers_as_df$diagnoser,
    lpr_diag = registers_as_df$lpr_diag,
    lpr_adm = registers_as_df$lpr_adm,
    sysi = registers_as_df$sysi,
    sssy = registers_as_df$sssy,
    lab_forsker = registers_as_df$lab_forsker,
    bef = registers_as_df$bef,
    lmdb = registers_as_df$lmdb
  )

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "data.frame")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})
