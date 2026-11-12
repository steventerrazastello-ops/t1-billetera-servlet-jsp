package pe.edu.upn.billetera.model;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Billetera implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    public static final BigDecimal SALDO_INICIAL = new BigDecimal("250.00");

    private BigDecimal saldo;
    private final List<Movimiento> movimientos;

    public Billetera() {
        this.saldo = SALDO_INICIAL;
        this.movimientos = new ArrayList<>();
    }

    public BigDecimal getSaldo() {
        return saldo;
    }

    public List<Movimiento> getMovimientos() {
        return Collections.unmodifiableList(movimientos);
    }

    public void registrarRecarga(BigDecimal monto) {
        saldo = saldo.add(monto);
        movimientos.add(0, new Movimiento("Recarga", monto, LocalDateTime.now()));
    }

    public void registrarGasto(BigDecimal monto) {
        saldo = saldo.subtract(monto);
        movimientos.add(0, new Movimiento("Gasto", monto, LocalDateTime.now()));
    }
}
