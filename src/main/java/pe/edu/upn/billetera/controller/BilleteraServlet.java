package pe.edu.upn.billetera.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.upn.billetera.model.Billetera;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

@WebServlet(name = "BilleteraServlet", urlPatterns = "/billetera")
public class BilleteraServlet extends HttpServlet {

    private static final String ATRIBUTO_BILLETERA = "billetera";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        Billetera billetera = obtenerBilletera(session);

        request.setAttribute("saldo", billetera.getSaldo());
        request.setAttribute("movimientos", billetera.getMovimientos());
        trasladarMensaje(session, request, "mensajeExito");
        trasladarMensaje(session, request, "mensajeError");

        request.getRequestDispatcher("/WEB-INF/views/billetera.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);
        Billetera billetera = obtenerBilletera(session);
        String tipo = limpiar(request.getParameter("tipo"));
        String montoTexto = limpiar(request.getParameter("monto"));

        String error = validarTipo(tipo);
        BigDecimal monto = null;

        if (error == null) {
            if (montoTexto == null) {
                error = "Ingrese un monto.";
            } else {
                try {
                    monto = new BigDecimal(montoTexto);
                } catch (NumberFormatException exception) {
                    error = "El monto debe ser un número válido.";
                }
            }
        }

        if (error == null && monto.compareTo(BigDecimal.ZERO) <= 0) {
            error = "El monto debe ser mayor que cero.";
        }

        if (error == null && monto.scale() > 2) {
            error = "El monto debe tener como máximo dos decimales.";
        }

        if (error == null) {
            monto = monto.setScale(2, RoundingMode.UNNECESSARY);
            synchronized (billetera) {
                if ("gasto".equals(tipo) && monto.compareTo(billetera.getSaldo()) > 0) {
                    error = "El gasto no puede superar el saldo disponible.";
                } else if ("recarga".equals(tipo)) {
                    billetera.registrarRecarga(monto);
                } else {
                    billetera.registrarGasto(monto);
                }
            }
        }

        if (error == null) {
            session.setAttribute("mensajeExito", "Movimiento registrado correctamente.");
        } else {
            session.setAttribute("mensajeError", error);
        }

        response.sendRedirect(request.getContextPath() + "/billetera");
    }

    private Billetera obtenerBilletera(HttpSession session) {
        Object valorActual = session.getAttribute(ATRIBUTO_BILLETERA);
        if (valorActual instanceof Billetera billetera) {
            return billetera;
        }

        Billetera nuevaBilletera = new Billetera();
        session.setAttribute(ATRIBUTO_BILLETERA, nuevaBilletera);
        return nuevaBilletera;
    }

    private String validarTipo(String tipo) {
        if (tipo == null) {
            return "Seleccione un tipo de movimiento.";
        }
        if (!"recarga".equals(tipo) && !"gasto".equals(tipo)) {
            return "El tipo de movimiento no es válido.";
        }
        return null;
    }

    private String limpiar(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }
        return valor.trim();
    }

    private void trasladarMensaje(
            HttpSession session,
            HttpServletRequest request,
            String nombreAtributo
    ) {
        Object mensaje = session.getAttribute(nombreAtributo);
        if (mensaje != null) {
            request.setAttribute(nombreAtributo, mensaje);
            session.removeAttribute(nombreAtributo);
        }
    }
}
