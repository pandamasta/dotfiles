from django.db import models
from django.utils.timezone import now
from django.conf import settings

class BaseModel(models.Model):
    """Abstract base model with common timestamp fields."""
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class SoftDeleteManager(models.Manager):
    """Manager to return only active (non-soft deleted) records by default."""
    
    def get_queryset(self):
        return super().get_queryset().filter(deleted_at__isnull=True)


class SoftDeleteAllManager(models.Manager):
    """Manager to return all records, including soft deleted ones."""
    
    def get_queryset(self):
        return super().get_queryset()


class SoftDeleteMixin(models.Model):
    """Mixin to provide soft deletion functionality."""
    deleted_at = models.DateTimeField(blank=True, null=True)

    # Custom managers
    objects = SoftDeleteManager()  # Default: exclude soft-deleted
    all_objects = SoftDeleteAllManager()  # Include soft-deleted

    def soft_delete(self):
        """Mark the object as soft deleted by setting the deleted_at timestamp."""
        if not self.deleted_at:
            self.deleted_at = now()
            self.save(update_fields=['deleted_at'])

    def delete(self, *args, **kwargs):
        """Soft delete if DELETION_MODE is 'soft', otherwise perform hard delete."""
        if settings.DELETION_MODE == 'soft':
            self.soft_delete()
        else:
            super().delete(*args, **kwargs)

    def restore(self):
        """Restore the soft-deleted object by clearing deleted_at timestamp."""
        if self.deleted_at:
            self.deleted_at = None
            self.save(update_fields=['deleted_at'])

    def is_deleted(self):
        """Returns True if the record is soft deleted, otherwise False."""
        return bool(self.deleted_at)

    class Meta:
        abstract = True  # Ensure no database table is created for this mixin
