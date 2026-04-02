import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';

export interface SaleSummary {
  id: string;
  receiptNumber: string;
  statusId: number;
  totalAmount: number;
  totalPaidAmount: number;
  createdAt: string;
  itemsCount: number;
}

export interface PagedSalesResponse {
  items: SaleSummary[];
  pageNumber: number;
  pageSize: number;
  totalCount: number;
  totalPages: number;
}

@Injectable({
  providedIn: 'root'
})
export class SaleService {
  private http = inject(HttpClient);

  getSales(page = 1, pageSize = 10): Observable<PagedSalesResponse> {
    return this.http.get<PagedSalesResponse>(`${environment.apiUrl}/api/v1/sales`, {
      params: { page, pageSize }
    });
  }
}
