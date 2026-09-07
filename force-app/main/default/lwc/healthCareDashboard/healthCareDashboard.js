import { LightningElement } from 'lwc';

import getPatients
    from '@salesforce/apex/PatientService.getPatients';

import getAppointments
    from '@salesforce/apex/AppointmentService.getAppointments';

import getBills
    from '@salesforce/apex/BillingService.getBills';

import getMedicines
    from '@salesforce/apex/MedicineService.getMedicines';


export default class HealthCareDashboard extends LightningElement {

    // Data
    patients = [];
    appointments = [];
    bills = [];
    medicines = [];

    // UI state
    isLoading = true;
    errorMessage = '';

    // Summary values
    totalPatients = 0;
    upcomingAppointments = 0;
    pendingBillsCount = 0;
    pendingBillsAmount = 0;
    medicineAlerts = 0;

    // Table data
    appointmentRows = [];
    medicineRows = [];


    // Component initialization
    connectedCallback() {
        this.loadDashboard();
    }


    // Load all dashboard data
    async loadDashboard() {

        this.isLoading = true;
        this.errorMessage = '';

        try {

            const results = await Promise.all([
                getPatients(),
                getAppointments(),
                getBills(),
                getMedicines()
            ]);

            this.patients = results[0] || [];
            this.appointments = results[1] || [];
            this.bills = results[2] || [];
            this.medicines = results[3] || [];

            this.prepareDashboardData();

        } catch (error) {

            console.error('Dashboard Error:', error);

            this.errorMessage =
                this.getErrorMessage(error);

        } finally {

            this.isLoading = false;

        }
    }


    // Prepare dashboard information
    prepareDashboardData() {

        // -----------------------------
        // TOTAL PATIENTS
        // -----------------------------

        this.totalPatients = this.patients.length;


        // -----------------------------
        // UPCOMING APPOINTMENTS
        // -----------------------------

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const upcoming = this.appointments
            .filter(appointment => {

                if (!appointment.Appointment_Date__c) {
                    return false;
                }

                const appointmentDate =
                    new Date(appointment.Appointment_Date__c);

                appointmentDate.setHours(0, 0, 0, 0);

                return (
                    appointmentDate >= today &&
                    appointment.Status__c !== 'Cancelled' &&
                    appointment.Status__c !== 'Completed'
                );

            })
            .sort((a, b) => {

                return new Date(a.Appointment_Date__c) -
                       new Date(b.Appointment_Date__c);

            });


        this.upcomingAppointments = upcoming.length;


        // Show maximum 5 appointments
        this.appointmentRows = upcoming
            .slice(0, 5)
            .map(appointment => {

                return {
                    id: appointment.Id,
                    patientName:
                        appointment.Patient__r
                            ? appointment.Patient__r.Name
                            : 'Not Available',

                    doctorName:
                        appointment.Doctor__r
                            ? appointment.Doctor__r.Name
                            : 'Not Available',

                    date:
                        appointment.Appointment_Date__c
                            || 'Not Available',

                    time:
                        appointment.Appointment_Time__c
                            || 'Not Available',

                    status:
                        appointment.Status__c
                            || 'Not Available',

                    statusClass:
                        this.getAppointmentStatusClass(
                            appointment.Status__c
                        )
                };

            });


        // -----------------------------
        // PENDING BILLS
        // -----------------------------

        const pendingBills = this.bills.filter(bill => {

            return bill.Payment_Status__c === 'Pending' ||
                   bill.Payment_Status__c === 'Partially Paid';

        });


        this.pendingBillsCount =
            pendingBills.length;


        this.pendingBillsAmount =
            pendingBills.reduce(
                (total, bill) => {

                    const amount =
                        Number(bill.Total_Amount__c) || 0;

                    return total + amount;

                },
                0
            );


        // -----------------------------
        // MEDICINE ALERTS
        // -----------------------------

        const alertMedicines =
            this.medicines.filter(medicine => {

                return medicine.Medicine_Status__c === 'Low Stock' ||
                       medicine.Medicine_Status__c === 'Out of Stock';

            });


        this.medicineAlerts =
            alertMedicines.length;


        // Show maximum 5 medicine alerts
        this.medicineRows =
            alertMedicines
                .slice(0, 5)
                .map(medicine => {

                    return {
                        id: medicine.Id,

                        name:
                            medicine.Name,

                        stock:
                            medicine.Stock_Quantity__c ?? 0,

                        status:
                            medicine.Medicine_Status__c ||
                            'Not Available',

                        statusClass:
                            this.getMedicineStatusClass(
                                medicine.Medicine_Status__c
                            )
                    };

                });

    }


    // Appointment status styling
    getAppointmentStatusClass(status) {

        switch (status) {

            case 'Confirmed':
                return 'status-badge confirmed';

            case 'Scheduled':
                return 'status-badge scheduled';

            case 'Completed':
                return 'status-badge completed';

            case 'Cancelled':
                return 'status-badge cancelled';

            default:
                return 'status-badge';

        }
    }


    // Medicine status styling
    getMedicineStatusClass(status) {

        switch (status) {

            case 'Low Stock':
                return 'status-badge low-stock';

            case 'Out of Stock':
                return 'status-badge out-of-stock';

            case 'Available':
                return 'status-badge available';

            default:
                return 'status-badge';

        }
    }


    // Refresh button
    handleRefresh() {

        this.loadDashboard();

    }


    // Appointment table check
    get hasAppointments() {

        return this.appointmentRows.length > 0;

    }


    // Medicine table check
    get hasMedicineAlerts() {

        return this.medicineRows.length > 0;

    }


    // Error handling
    getErrorMessage(error) {

        if (error?.body?.message) {

            return error.body.message;

        }

        if (error?.message) {

            return error.message;

        }

        return 'Unable to load healthcare dashboard data.';

    }

}