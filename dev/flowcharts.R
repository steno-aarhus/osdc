# Draw flowcharts:
library(DiagrammeR)


# Diabetes:
draw_inclusion <- function() {

  grViz(
  "
      digraph inclusion {

      graph [rankdir = TB]

      node [style = 'rounded, filled', color = black, penwidth = 2]

      # Background population:
      backgr_pop [label = '@@1', shape = box, fillcolor = Tan, fontsize = 16, fontname = 'helvetica-bold', width = 17.55]


      # # Nodes for criteria/forks
      subgraph inclcriteria {
      node [shape = box, fillcolor = PaleTurquoise, fontsize = 16, fontname = 'helvetica-bold', width = 4.2]
      hba1c [label = '@@2']
      a10 [label = '@@3']
      lpr [label = '@@4']
      pod [label = '@@5']
      }


      # Censoring:
      node [shape = box, style = 'filled', shape = egg, fillcolor = Salmon, fontsize = 16, fontname = 'helvetica-bold', margin = '0.2, 0.1']
      gdm_yes [label = '@@6']
      a10_pcos_yes [label = '@@7']
      one_event_yes [label = '@@8']


      # Exclusion Nodes:

      node [shape = diamond, fillcolor = red]
      gdm_out [label = 'Gestational \n diabetes']
      pcos_out [label = 'Polycystic \n ovary syndrome']
      one_event_out [label = 'Misclassification']


      # Diabetes Nodes:
      valid_events [shape = circle, fillcolor = LightGoldenrodYellow, fixedsize = true, width = 2, label = '@@9']
      diabetes [shape = doublecircle, fillcolor = Gold, fixedsize = true, width = 2.5, label = '@@10']

      # Diabetes types:
      t2d [shape = doublecircle, fillcolor = Goldenrod, fixedsize = true, width = 2, label = 'Type 2 \\n diabetes']
      t1d [shape = doublecircle, fillcolor = Green3, fixedsize = true, width = 2, label = 'Type 1 \\n diabetes']


       # Edge statements:
      edge [color = black]

      # Multiple valid events to diabetes:
      one_event_yes -> one_event_out
      valid_events -> {one_event_yes diabetes}

      # Exclusion of invalid events:
      gdm_yes -> gdm_out
      a10_pcos_yes -> pcos_out

      # Inclusion events:
      backgr_pop -> {a10 hba1c lpr pod}
      hba1c -> {gdm_yes valid_events}
      a10 -> {gdm_yes a10_pcos_yes valid_events}
      {lpr pod} -> valid_events

      # Diabetes type:

      diabetes -> {t2d t1d}




      #Adjusting ranks with invisible nodes for orderly output:
      {rank = same
      a10 -> hba1c -> lpr -> pod [style = invis]
      rankdir = LR}

      {rank = same
      gdm_yes -> a10_pcos_yes -> one_event_yes -> diabetes -> t2d [style = invis]
      rankdir = LR}

      {rank = same
      gdm_out -> pcos_out -> one_event_out -> t1d [style = invis]
      rankdir = LR}



      }

  [1]: paste(' Background population:', '\\n', format(n_background, big.mark = ',', trim = TRUE))
  [2]: paste(' P-HbA1c tests: \\n 48 mmol/mol or above', '\\n', format(n_incl_event_hba1c, big.mark = ',', trim = TRUE))
  [3]: paste(' Prescriptions redeemed: \\n Glucose lowering drugs', '\\n', format(n_incl_event_a10, big.mark = ',', trim = TRUE))
  [4]: paste(' Hospital diagnoses: \\n Diabetes', '\\n', format(n_incl_event_lpr, big.mark = ',', trim = TRUE))
  [5]: paste(' Health services: \\n Diabetes-specific podiatrist services', '\\n', format(n_incl_event_foot, big.mark = ',', trim = TRUE))
  [6]: paste(' Registered \\n during pregnancy:', '\\n', format(n_censored_events_a10_gdm + n_censored_events_hba1c_gdm, big.mark = ',', trim = TRUE))
  [7]: paste(' Metformin in \\n women below age 40 \\n or indication code PCOS:', '\\n', format(n_censored_events_a10_pcos, big.mark = ',', trim = TRUE))
  [8]: paste(' Only one event:', '\\n', format(n_only_1_event, big.mark = ',', trim = TRUE))
  [9]: paste(' Inclusion \\n events:', '\\n', format(n_any_valid_events, big.mark = ',', trim = TRUE))
  [10]: paste(' 2nd inclusion event: \\n Diabetes:', '\\n', format(n_dm, big.mark = ',', trim = TRUE))

  ")

}

# Type:

draw_type <- function(sample_year) {

  load(here("data", "source", "years", "flowchart", sample_year,
            paste0("flowchart_counts_", sample_year, ".Rdata")), envir =  .GlobalEnv)

  grViz("
      digraph dm_type {

      graph [rankdir = TB]

      node [fontname = 'helvetica-bold', fontsize = 18, fixedsize = FALSE, style = 'rounded, filled', color = black, penwidth = 2, margin = '0.2, 0.1']

      # Nodes for criteria/forks
      node [shape = box, fillcolor = PaleTurquoise]
      insulin_mono [label = ' All prescriptions of GLD are insulins? ', width = 6]
      less_3_t2d_or_1_t1d [label = ' At least one T1D primary diagnosis? \n (from endocrinological or medical specialties) ', width = 6]
      insulin_prev_year [label = ' Insulin during \n the previous year? \n (prior to 2018)']
      any_t1d_diags [label = ' At least one primary diagnosis of T1D? \n (from endocrinological or medical specialties) ', width = 6]
      any_t1d_diags_endo [label = ' From endocrinological \n specialty? ']
      majority_endo_diags [label = ' Majority of T1D vs. T2D \n primary diagnoses? \n (endocrinological specialty) ']
      majority_medical_diags [label = ' Majority of T1D vs. T2D \n primary diagnoses? \n (medical specialties) ']
      a10a_first_double [label = ' Insulin within 180 days of onset \n and insulin constitutes \n >2/3 of all GLD doses? ', margin = '0.3, 0.1']
      total_t1d_cohort [label = '@@20']
      total_t2d_cohort [label = '@@21']
      prevalent_alive_index_t1d [label = '@@22']
      prevalent_alive_index_t2d [label = '@@23']


      backgr_dm [label = '@@1', fillcolor = Gold, width = 13]

      # Positive Nodes:
      node [style = 'filled', shape = diamond, fillcolor = PaleGreen, fixedsize = TRUE, width = 1.5, height = 1.5]
      insulin_mono_yes [label = '@@2']
      less_3_t2d_or_1_t1d_yes [label = '@@3']
      insulin_prev_year_yes [label = '@@4']
      any_t1d_diags_yes [label = '@@5']
      any_t1d_diags_endo_yes [label = '@@6']
      any_t1d_diags_endo_no [label = '@@14']
      majority_endo_diags_yes [label = '@@7']
      majority_medical_diags_yes [label = '@@8']
      a10a_first_double_yes [label = '@@9']


      # Negative Nodes:
      node [shape = diamond, fillcolor = Salmon, fixedsize = TRUE, width = 1.5, height = 1.5]
      insulin_mono_no [label = '@@10']
      less_3_t2d_or_1_t1d_no [label = '@@11']
      insulin_prev_year_no [label = '@@12']
      any_t1d_diags_no [label = '@@13']
      majority_endo_diags_no [label = '@@15']
      majority_medical_diags_no [label = '@@16']
      a10a_first_double_no [label = '@@17']

      # Diabetes Nodes:
      node [shape = doublecircle, width = 3]
      T1D [label = '@@18', fillcolor = Green3]
      T2D [label = '@@19', fillcolor = Goldenrod]


      # Edge statements:
      edge [color = black]

      backgr_dm -> insulin_mono

      # Insulin monotherapy?:
      insulin_mono -> {insulin_mono_yes insulin_mono_no}

        # Insulin monotherapy YES + check for diagnoses and insulin in past year:
        insulin_mono_yes -> less_3_t2d_or_1_t1d
        less_3_t2d_or_1_t1d -> {less_3_t2d_or_1_t1d_yes less_3_t2d_or_1_t1d_no}
        less_3_t2d_or_1_t1d_yes -> total_t1d_cohort
        total_t1d_cohort -> prevalent_alive_index_t1d
        prevalent_alive_index_t1d -> insulin_prev_year
        insulin_prev_year -> {insulin_prev_year_yes insulin_prev_year_no}
        insulin_prev_year_yes -> T1D
        insulin_prev_year_no -> T2D
        less_3_t2d_or_1_t1d_no -> total_t2d_cohort

        # Insulin monotherapy NO:
        insulin_mono_no -> any_t1d_diags

                # Have T1D primary diagnoses:
                any_t1d_diags -> {any_t1d_diags_yes any_t1d_diags_no}
                any_t1d_diags_no -> total_t2d_cohort
                total_t2d_cohort -> prevalent_alive_index_t2d
                prevalent_alive_index_t2d -> T2D

                # From endo departments:
                any_t1d_diags_yes -> any_t1d_diags_endo
                any_t1d_diags_endo -> {any_t1d_diags_endo_yes any_t1d_diags_endo_no}

                any_t1d_diags_endo_yes -> majority_endo_diags
                majority_endo_diags -> {majority_endo_diags_yes majority_endo_diags_no}

                # From medical departments
                any_t1d_diags_endo_no -> majority_medical_diags

                majority_medical_diags -> {majority_medical_diags_yes majority_medical_diags_no}

                # No majority
                {majority_endo_diags_no majority_medical_diags_no} -> total_t2d_cohort

                # Those with a majority of T1D vs. T2D diagnoses undergo medication check:
                {majority_endo_diags_yes majority_medical_diags_yes} -> a10a_first_double

                a10a_first_double -> {a10a_first_double_yes a10a_first_double_no}
                a10a_first_double_yes -> total_t1d_cohort
                a10a_first_double_no -> total_t2d_cohort



      # Adjusting ranks with invisible nodes for orderly output:
      {rank = same
      insulin_mono_yes -> insulin_mono_no [style = invis]
      rankdir = LR}

      {rank = same
      less_3_t2d_or_1_t1d -> any_t1d_diags [style = invis]
      rankdir = LR}


      {rank = same
      any_t1d_diags_yes -> any_t1d_diags_no  [style = invis]
      rankdir = LR}

      {rank = same
      less_3_t2d_or_1_t1d_yes -> less_3_t2d_or_1_t1d_no -> majority_endo_diags_yes -> majority_medical_diags_yes -> majority_endo_diags_no -> majority_medical_diags_no [style = invis]
      rankdir = LR}

      {rank = same
      a10a_first_double_yes -> a10a_first_double_no [style = invis]
      rankdir = LR}

      {rank = same
      insulin_prev_year_yes -> insulin_prev_year_no [style = invis]
      rankdir = LR}

      {rank = same
      prevalent_alive_index_t1d -> prevalent_alive_index_t2d [style = invis]
      rankdir = LR}

      {rank = same
      T1D -> T2D [style = invis]
      rankdir = LR}

      }

      [1]: paste(' Diabetes population:', '\\n', format(n_dm, big.mark = ',', trim = TRUE))
      [2]: paste(' Yes:', '\\n', format(n_insulin_mono_yes, big.mark = ',', trim = TRUE))
      [3]: paste(' Yes:', '\\n', format(n_3_t2d_or_1_t1d_yes, big.mark = ',', trim = TRUE))
      [4]: paste(' Yes:', '\\n', format(n_insulin_prev_year_left_yes + n_insulin_prev_year_right_yes, big.mark = ',', trim = TRUE))
      [5]: paste(' Yes:', '\\n', format(n_any_t1d_diags_yes, big.mark = ',', trim = TRUE))
      [6]: paste(' Yes:', '\\n', format(n_any_t1d_diags_endo_yes, big.mark = ',', trim = TRUE))
      [7]: paste(' Yes:', '\\n', format(n_majority_endo_diags_yes, big.mark = ',', trim = TRUE))
      [8]: paste(' Yes:', '\\n', format(n_majority_medical_diags_yes, big.mark = ',', trim = TRUE))
      [9]: paste(' Yes:', '\\n', format(n_a10a_first_double_yes, big.mark = ',', trim = TRUE))
      [10]: paste(' No:', '\\n', format(n_insulin_mono_no, big.mark = ',', trim = TRUE))
      [11]: paste(' No:', '\\n', format(n_3_t2d_or_1_t1d_no, big.mark = ',', trim = TRUE))
      [12]: paste(' No:', '\\n', format(n_insulin_prev_year_left_no + n_insulin_prev_year_right_no, big.mark = ',', trim = TRUE))
      [13]: paste(' No:', '\\n', format(n_any_t1d_diags_no, big.mark = ',', trim = TRUE))
      [14]: paste(' No:', '\\n', format(n_any_t1d_diags_endo_no, big.mark = ',', trim = TRUE))
      [15]: paste(' No:', '\\n', format(n_majority_endo_diags_no, big.mark = ',', trim = TRUE))
      [16]: paste(' No:', '\\n', format(n_majority_medical_diags_no, big.mark = ',', trim = TRUE))
      [17]: paste(' No:', '\\n', format(n_a10a_first_double_no, big.mark = ',', trim = TRUE))
      [18]: paste(' Type 1 diabetes \\n prevalence:', '\\n', format(n_t1d_postcrop, big.mark = ',', trim = TRUE))
      [19]: paste(' Type 2 diabetes \\n prevalence:', '\\n', format(n_t2d_postcrop, big.mark = ',', trim = TRUE))
      [20]: paste(' T1D \\n at any time:', '\\n', format(n_3_t2d_or_1_t1d_yes + n_a10a_first_double_yes, big.mark = ',', trim = TRUE))
      [21]: paste(' T2D \\n at any time:', '\\n', format(n_3_t2d_or_1_t1d_no + n_any_t1d_diags_no + n_majority_endo_diags_no + n_majority_endo_diags_no + n_majority_medical_diags_no + n_a10a_first_double_no, big.mark = ',', trim = TRUE))
      [22]: paste(' Preliminary T1D \\n on index date: ', '\\n', format(n_t1d_precrop, big.mark = ',', trim = TRUE))
      [23]: paste(' Preliminary T2D \\n on index date: ', '\\n', format(n_t2d_precrop, big.mark = ',', trim = TRUE))

      ")

}
