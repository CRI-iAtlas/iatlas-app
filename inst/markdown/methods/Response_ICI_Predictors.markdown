**Title:** Predictors of Response to Immune Checkpoint Inhibitor immunotherapy

**Description:** Potential predictors of response to Immune Checkpoint Inhibitors
  therapy were computed for all samples in the datasets in the Molecular Response to ICI modules.


*Obtaining gene counts:* STAR v2.4.2(Dobin, et al., 2013) was used to align RNA-seq paired fastq reads to the transcript coordinates of hg38. Read mappings to gene isoforms were counted using Salmon v1.1.0(Patro, et al., 2017).  These isoform counts were mapped to genes using biomart(Durinck, et al., 2009) and summed for gene-level counts.


*Diversity calculation:* RNA-seq paired fastq reads were processed using MiXCR v2.1.9(Bolotin, et al., 2015) using the IMGT v201802-5.sv2(Lefranc, 2011) library. Two partial alignments were performed with one extension phase.  Abundance was taken as the sum of reads for each clone. Richness was the total number of clones. Chao1(Chiu, et al., 2014) and Shannon entropy(Shannon, 1948) were calculated using the R Package vegan. Evenness was calculated as Shannon entropy / Log(Richness)(Pielou, 1966). d25, d50 and d75 (dXX) indices were calculated as described by VDJTools(Shugay, et al., 2015) GitHub repository: “The estimate equals to 1 - n / N, where n is the minimum number of clonotypes accounting for at least XX% of the total reads and code N is the total number of clonotypes in the sample.”

*CIBERSORTx:* CIBERSORTx scores were obtained as described(Newman, et al., 2019).


*IMPRES:* IMPRES scores were calculated as described(Auslander, et al., 2018) and implemented in the Vincent Lab R-package, binfotron::calc_impres (devtools::install_github("Benjamin-Vincent-Lab/binfotron").


*ICP Ratios:* Biocarta or Reactome CTLA4 signature normalized by the Bindea signature (eg CTLA vs Th1: BIOCARTA_CTLA4_PATHWAY signature score / Bindea_Th1_Cells signature score)


*Gene signature derivation:* Gene signatures were derived by running DESeq2(Love, et al., 2014) on gene count data and grouping the significant up and down genes in their respective signatures.


*Gene signature calculations:* Gene counts were upper-quartile normalized and then log2 transformed, log2(normalized counts +1).  Signatures were calculated as the median log2-transformed value of the genes in a given gene signature.


*Gene signature sources:*

Beck_Mac_CSF1(Beck, et al., 2009)

Bindea_BCells, Bindea_aDC, Bindea_DC, Bindea_Eosinophils, Bindea_iDC, Bindea_Mast_Cells, Bindea_Neutrophils, Bindea_NK_CD56bright, Bindea_NK_CD56dim, Bindea_NK_Cells, Bindea_pDC, Bindea_Tcm, Bindea_Tem, Bindea_TFH, Bindea_Tgd, Bindea_CD8_TCells, Bindea_TCells, Bindea_THelper, Bindea_Th1_Cells, Bindea_Th2_Cells, Bindea_Th17_Cells, Bindea_TReg, Bindea_Cytotoxic_Cells, Bindea_Macrophages(Bindea, et al., 2013)

BIOCARTA_CTLA4_PATHWAY(Nishimura, 2004)

Chan_TIC(Chan, et al., 2009)

Chang_Serum_Response_Up, CSF1_Response, LIexpression_Score, Module3_IFN_Score, TGFB_Score(Thorsson, et al., 2018)

Cytolytic_Score(Roufas, et al., 2018)

Fan_IGG(Fan, et al., 2011)

GO_BCR_Signaling(Gene Ontology terms 0050853 - GO:0050853)

GO_TCR_Signaling(Gene Ontology terms 0050852 - GO:0050852)

IglesiaVincent_BCell, IglesiaVincent_CD8, IglesiaVincent_CD68, IglesiaVincent_MacTh1, IglesiaVincent_TCell (Iglesia, et al., 2014)

KardosChai_ImSuppress, KardosChai_EMT_DOWN, KardosChai_EMT_UP (Kardos, et al., 2016)

Palmer_BCell, Palmer_CD8, Palmer_TCell(Palmer, et al., 2006)

Prat_Claudin(Prat, et al., 2010)

REACTOME_CTLA4_INHIBITORY_SIGNALING, REACTOME_PD1_SIGNALING (Subramanian, et al., 2005)

Rody_IL8, Rody_LCK, Rody_TNBC_BCell, Rody_TNBC_TCell (Rody, et al., 2009)

Schmidt_BCell(Schmidt, et al., 2008)

IPRES Signatures(Hugo, et al., 2016)

Hugo_Responder - all genes up in responders from their analysis

Hugo_FDR_Responder - fdr significant genes from all_re_siggenes

Hugo_NonResponder - all genes up in non-responders from their analysis

Hugo_FDR_NonResponder - fdr significant genes from all_nr_siggenes

Hugo_IPRES26 - IPRES gene set; IPRES06 plus similar gene sets

Hugo_IPRES22 - IPRES26 minus 4 Hugo et.al. dropped for subsequent analysis

Hugo_IPRES08 - original significant sets Hugo et.al. found in creating IPRES

Hugo_IPRES06 - IPRES08 minus 2 gene sets Hugo et.al. felt weren't similar

Vincent_IPRES_Responder – Vincent Lab analysis of Hugo et.al. data; genes up in responders

Vincent_IPRES_NonResponder - Vincent Lab analysis of Hugo data; genes up in non-responders


**Datasets**

Gide_Cell_2019(Gide, et al., 2019)

HugoLo_IPRES_2016(Hugo, et al., 2016)

IMVigor210(Balar, et al., 2017; Rosenberg, et al., 2016)

Prins_GBM_2019(Cloughesy, et al., 2019)

Riaz_Nivolumab_2017(Riaz, et al., 2017)

VanAllen_antiCTLA4_2015(Van Allen, et al., 2015)


**References**

Auslander, N., et al. Robust prediction of response to immune checkpoint blockade therapy in metastatic melanoma. Nat Med 2018;24(10):1545-1549.

Balar, A.V., et al. Atezolizumab as first-line treatment in cisplatin-ineligible patients with locally advanced and metastatic urothelial carcinoma: a single-arm, multicentre, phase 2 trial. Lancet 2017;389(10064):67-76.

Beck, A.H., et al. The macrophage colony-stimulating factor 1 response signature in breast carcinoma. Clin Cancer Res 2009;15(3):778-787.

Bindea, G., et al. Spatiotemporal dynamics of intratumoral immune cells reveal the immune landscape in human cancer. Immunity 2013;39(4):782-795.

Bolotin, D.A., et al. MiXCR: software for comprehensive adaptive immunity profiling. Nat Methods2015;12(5):380-381.

Chan, K.S., et al. Identification, molecular characterization, clinical prognosis, and therapeutic targeting of human bladder tumor-initiating cells. Proc Natl Acad Sci U S A 2009;106(33):14016-14021.

Chiu, C.H., et al. An improved nonparametric lower bound of species richness via a modified good-turing frequency formula. Biometrics 2014;70(3):671-682.

Cloughesy, T.F., et al. Neoadjuvant anti-PD-1 immunotherapy promotes a survival benefit with intratumoral and systemic immune responses in recurrent glioblastoma. Nat Med 2019;25(3):477-486.

Dobin, A., et al. STAR: ultrafast universal RNA-seq aligner. Bioinformatics 2013;29(1):15-21.

Durinck, S., et al. Mapping identifiers for the integration of genomic datasets with the R/Bioconductor package biomaRt. Nat Protoc 2009;4(8):1184-1191.

Fan, C., et al. Building prognostic models for breast cancer patients using clinical variables and hundreds of gene expression signatures. BMC Med Genomics 2011;4:3.

Gide, T.N., et al. Distinct Immune Cell Populations Define Response to Anti-PD-1 Monotherapy and Anti-PD-1/Anti-CTLA-4 Combined Therapy. Cancer Cell 2019;35(2):238-255 e236.

Hugo, W., et al. Genomic and Transcriptomic Features of Response to Anti-PD-1 Therapy in Metastatic Melanoma. Cell 2016;165(1):35-44.
Iglesia, M.D., et al. Prognostic B-cell signatures using mRNA-seq in patients with subtype-specific breast and ovarian cancer. Clin Cancer Res 2014;20(14):3818-3829.

Kardos, J., et al. Claudin-low bladder tumors are immune infiltrated and actively immune suppressed. JCI Insight 2016;1(3):e85902.

Lefranc, M.P. IMGT, the International ImMunoGeneTics Information System. Cold Spring Harb Protoc2011;2011(6):595-603.

Love, M.I., Huber, W. and Anders, S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol 2014;15(12):550.

Newman, A.M., et al. Determining cell type abundance and expression from bulk tissues with digital cytometry. Nat Biotechnol 2019;37(7):773-782.

Nishimura, D. A View From the Web: BioCarta. Biotechnology Software & Internet Journal 2004;2(3):117-120.

Palmer, C., et al. Cell-type specific gene expression profiles of leukocytes in human peripheral blood. BMC Genomics 2006;7:115.

Patro, R., et al. Salmon provides fast and bias-aware quantification of transcript expression. Nat Methods2017;14(4):417-419.

Pielou, E.C. Species-diversity and pattern-diversity in the study of ecological succession. J Theor Biol1966;10(2):370-383.

Prat, A., et al. Phenotypic and molecular characterization of the claudin-low intrinsic subtype of breast cancer. Breast Cancer Res 2010;12(5):R68.

R Core Team. 2014. R: A language and environment for statistical computing. http://www.R-project.org/

Riaz, N., et al. Tumor and Microenvironment Evolution during Immunotherapy with Nivolumab. Cell2017;171(4):934-949 e916.

Rody, A., et al. T-cell metagene predicts a favorable prognosis in estrogen receptor-negative and HER2-positive breast cancers. Breast Cancer Res 2009;11(2):R15.

Rosenberg, J.E., et al. Atezolizumab in patients with locally advanced and metastatic urothelial carcinoma who have progressed following treatment with platinum-based chemotherapy: a single-arm, multicentre, phase 2 trial. Lancet 2016;387(10031):1909-1920.

Roufas, C., et al. The Expression and Prognostic Impact of Immune Cytolytic Activity-Related Markers in Human Malignancies: A Comprehensive Meta-analysis. Front Oncol 2018;8:27.

Schmidt, M., et al. The humoral immune system has a key prognostic impact in node-negative breast cancer. Cancer Res 2008;68(13):5405-5413.

Shannon, C.E. A Mathematical Theory of Communication. The Bell System Technical Journal 1948;27:379–423, 623–656.

Shugay, M., et al. VDJtools: Unifying Post-analysis of T Cell Receptor Repertoires. PLoS Comput Biol2015;11(11):e1004503.

Subramanian, A., et al. Gene set enrichment analysis: a knowledge-based approach for interpreting genome-wide expression profiles. Proc Natl Acad Sci U S A 2005;102(43):15545-15550.

Van Allen, E.M., et al. Genomic correlates of response to CTLA-4 blockade in metastatic melanoma. Science2015;350(6257):207-211.


**Contributors:** Dante Bortone, Sarah Entwistle, Benjamin Vincent

