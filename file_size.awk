                                                                   
BEGIN {
        threshold = 44000
        alert_log = "/var/log/file-size-alerts.log"

        if ((getline _ < alert_log) < 0) {
                print "Log file does not exist" > "/dev/stderr"
                exit 1
        }

        close(alert_log)

}

{
    x = $5      # size from ls -l
    filename = $9
    if (x > threshold) {
        msg = filename ": Higher than 44K"
        print msg
        print msg >> alert_log
        close(alert_log)
    }
}

