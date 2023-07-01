from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from datetime import datetime

pdfmetrics.registerFont(TTFont('FreeSansBold', 'src/invoices/FreeSansBold.ttf'))
pdfmetrics.registerFont(TTFont('FreeSans', 'src/invoices/FreeSans.ttf'))


def generate_unique_invoice_number():
    return datetime.now().strftime("%m%d%H%M%S")


def get_font_styles():
    styles = getSampleStyleSheet()
    heading_style = ParagraphStyle(
        'Heading1',
        parent=styles['Heading1'],
        fontName='FreeSansBold',
        fontSize=14,
        leading=16,
        encoding='utf-8',
    )
    normal_style = ParagraphStyle(
        'Normal',
        parent=styles['Normal'],
        fontName='FreeSans',
        fontSize=10,
        leading=12,
        encoding='utf-8',
    )
    return heading_style, normal_style


def get_table_style():
    return TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.lightgrey),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'FreeSans'),
        ('FONTSIZE', (0, 0), (-1, 0), 12),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('FONTNAME', (0, 1), (-1, -1), 'FreeSans'),
        ('FONTSIZE', (0, 1), (-1, -1), 10),
        ('LEADING', (0, 1), (-1, -1), 12),
        ('FONTENCODING', (0, 1), (-1, -1), 'utf-8'),
    ])


def get_company_info():
    return [
        ["Nazwa firmy", "VetCare Sp. z o.o."],
        ["Adres", "ul. Słoneczna 10, 00-024 Warszawa, POL"],
        ["NIP", "5222961478"],
        ["tel.", "742 293 292"],
    ]


def get_items_and_total_cost(invoice_items, vat_rate=8):
    total_cost = 0
    table_headers = ['Lp.', 'Nazwa towaru', 'VAT', 'Ilość', 'Cena netto', 'Cena brutto', 'Razem']
    item_data = [table_headers]
    for i, item in enumerate(invoice_items, start=1):
        item_cost = item['price_brutto'] * item['quantity']
        item_row = [
            str(i),
            item['name'],
            f"{vat_rate}%",
            str(item['quantity']),
            f"{(item['price_brutto'] / (1 + vat_rate * 0.01)):.2f} PLN".replace(".", ","),
            f"{item['price_brutto']:.2f} PLN".replace(".", ","),
            f"{item_cost:.2f} PLN".replace(".", ","),
        ]
        total_cost += item_cost
        item_data.append(item_row)
    return item_data, total_cost


def prepare_invoice_content(invoice_data, invoice_number):
    heading_style, normal_style = get_font_styles()
    table_style = get_table_style()
    header = Paragraph(f"Faktura VAT nr {invoice_number}", heading_style)
    content = [header, Spacer(1, 20)]

    # Dane firmy
    company_table = Table(get_company_info(), colWidths=[80 * mm, None])
    company_table.setStyle(table_style)
    content.append(company_table)
    content.append(Spacer(1, 20))

    # Dane nabywcy
    content.append(Paragraph("Dane nabywcy:", heading_style))
    content.append(Paragraph(f"Imię i nazwisko: {invoice_data.name} {invoice_data.surname}",
                             normal_style))
    content.append(Paragraph(f"Adres: {invoice_data.address} \n POL", normal_style))
    content.append(Paragraph("NIP: BRAK", normal_style))
    content.append(Spacer(1, 20))

    # Informacje dodatkowe
    content.append(Paragraph(f"Data sprzedaży: {invoice_data.date}", normal_style))
    content.append(Paragraph(f"Data płatności: {invoice_data.date_paid}", normal_style))
    content.append(Paragraph(f"Sposób płatności: {invoice_data.method_of_payment}", normal_style))
    content.append(Spacer(1, 20))

    # Pozycje faktury
    content.append(Paragraph("Pozycje faktury:", heading_style))
    # Ze względu na brak danych o cenach poszczególnych usług, zakładam, że faktura dotyczy jednej ogólnej pozycji,
    # a cena za wizytę ustalana jest indywidualnie przez lekarza
    invoice_items = [
            {
                "name": "Konsultacja weterynaryjna",
                "quantity": 1,
                "price_brutto": float(invoice_data.amount),
            }
        ]
    items_data, total_cost = get_items_and_total_cost(invoice_items)
    item_table = Table(items_data, colWidths=[20 * mm, None, 20 * mm, 20 * mm, 30 * mm, 30 * mm, 30 * mm])
    item_table.setStyle(table_style)
    content.append(item_table)
    content.append(Spacer(1, 20))

    # Podsumowanie
    content.append(Paragraph(f"Do zapłaty: {total_cost:.2f} PLN".replace(".", ","), heading_style))
    content.append(Spacer(1, 20))
    content.append(Paragraph(77 * "_", normal_style))
    return content


def generate_invoice_pdf(invoice_data):
    invoice_number = generate_unique_invoice_number()
    pdf = SimpleDocTemplate(f"Faktura_{invoice_number}.pdf", pagesize=A4)
    content = prepare_invoice_content(invoice_data, invoice_number)
    pdf.build(content)
