# Power BI Desktop build guide

## Import
1. Open Power BI Desktop → Get data → Excel workbook.
2. Import the provided `Alcovia_GTM_PowerBI_Starter.xlsx` sheets.
3. Use `DimDate[Date]` for date slicers. Create one-to-many, single-direction relationships to each fact table's primary date.
4. Mark `DimDate` as the date table.
5. Keep stage-event reporting separate from lead-created-date reporting. Avoid ambiguous active date relationships.

## Recommended report pages
1. Executive Overview: collected revenue, ad spend, qualified leads, cost per qualified lead, revenue trend, revenue type split, outstanding invoices, upcoming renewals.
2. Funnel: lead counts by stage, stage-to-stage conversion, average journey duration, drop-off table.
3. Campaigns: spend, CTR, CPC, qualified leads, cost per qualified lead, landing-page conversion, frequency.
4. Revenue & Follow-ups: target vs actual by month and revenue type, payment status, invoices, trial renewals.

## Starter DAX
```dax
Total Ad Spend = SUM(FactCampaignDaily[SpendINR])

Total Leads = DISTINCTCOUNT(FactLeads[LeadID])

Qualified Leads =
CALCULATE(
    DISTINCTCOUNT(FactLeads[LeadID]),
    FactLeads[IsQualified] = TRUE()
)

Paid Leads =
CALCULATE(
    DISTINCTCOUNT(FactLeads[LeadID]),
    FactLeads[IsPaid] = TRUE()
)

Cost per Qualified Lead = DIVIDE([Total Ad Spend], [Qualified Leads])

Lead Qualification Rate = DIVIDE([Qualified Leads], [Total Leads])

Total Collected Revenue =
CALCULATE(
    SUM(FactPayments[GrossAmountINR]) - SUM(FactPayments[RefundINR]),
    FactPayments[PaymentStatus] = "Paid"
)

Outstanding Invoices = SUM(FactInvoices[OutstandingINR])
```

## Important modelling notes
- Campaign daily lead totals and distinct lead records may overlap; do not add them together.
- Revenue target data is monthly. Compare monthly actuals with monthly targets at the same grain.
- A lead's current stage cannot reconstruct historical stage conversion by itself. Use stage-transition events with timestamps.
- Define whether revenue is cash collected, booked revenue, or net of refunds before publishing.
- The included workbook is fictional test data, not Alcovia performance.
- Power BI Desktop alone does not produce a shareable live report link. Publishing requires approved Power BI Service access or a different approved hosting approach.
