export class LinkProgressData{
  private _dlTotal: number | undefined | null;

  public set dlTotal(value: number | undefined | null) {
    this._dlTotal = value;
  }

  public get dlTotal(): number | undefined | null {
    return this._dlTotal;
  }

  private _dlNow: number | undefined | null;

  public set dlNow(value: number | undefined | null) {
    this._dlNow = value;
  }

  public get dlNow(): number | undefined | null {
    return this._dlNow;
  }

  private _ulTotal: number | undefined | null;

  public set ulTotal(value: number | undefined | null) {
    this._ulTotal = value;
  }

  public get ulTotal(): number | undefined | null {
    return this._ulTotal;
  }

  private _ulNow: number | undefined | null;

  public set ulNow(value: number | undefined | null) {
    this._ulNow = value;
  }

  public get ulNow(): number | undefined | null {
    return this._ulNow;
  }

  constructor(dlTotal: number | undefined | null, dlNow: number | undefined | null, ulTotal: number | undefined | null, ulNow: number | undefined | null) {
    this._dlTotal = dlTotal;
    this._dlNow = dlNow;
    this._ulTotal = ulTotal;
    this._ulNow = ulNow;
  }
}